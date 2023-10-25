import time
from random import randint
from copy import deepcopy
from threading import Thread, Condition, Lock
from xml.etree.ElementTree import TreeBuilder

from flask import Flask
from flask_mqtt import Mqtt

from app.models import Device, User
from app.models.db import db
from app.mqtt.mqtt_message import MqttMesssage, SetEnergyLevelSignal, ShutdownSignal, StartupSignal

# TODO remove after testing
SECONDS_PER_HOUR = 10


class ScheduleState:
    """Class for representing scheduler internal state"""

    PUBLISH = "publish"
    EXEC_SYNC = "execs"
    EXEC_BACKGROUND = "execb"

    def __init__(self):

        self.queue = []
        """FIFO queue that accumulates requests from every module of this app\n
            it is usually populated by ScheduleHandlers or, for example, anomaly detection routines"""

        self.info = {}
        """Dictionary to represent current state"""

        self.info_lock = Lock()

        self.wakeup = Condition()
        """Variable that, when notified, wakes up the scheduler"""

    def notify(self):
        """Notify wakeup condition"""

        self.wakeup.acquire(True)
        self.wakeup.notify()
        self.wakeup.release()

    def assign_publish(self, channel, content):

        if type(content) == str:
            content = content.encode()

        self.queue.append((ScheduleState.PUBLISH, channel, content))

    def assign_exec_sync(self, to_call, kwargs):

        if type(to_call) != str:
            to_call = to_call.__name__

        self.queue.append((ScheduleState.EXEC_SYNC, to_call, kwargs))

    def assign_exec_background(self, to_call, kwargs):

        if type(to_call) != str:
            to_call = to_call.__name__

        self.queue.append((ScheduleState.EXEC_BACKGROUND, to_call, kwargs))


class ScheduleHandlers:
    """Collection of all (default) schedule-related handlers\n
        Rules for implementing a handler:\n
        1. every handler must receive as first argument the current state\n
        2. for multithreading safety, lock before using info from (the) state object\n
        """

    def global_shutdown(current_state: ScheduleState):
        """Global shutdown broadcast"""

        current_state.info_lock.acquire()
        global_channel = current_state.info["global_channel"]
        current_state.info_lock.release()

        current_state.assign_publish(global_channel, ShutdownSignal().pack())
        current_state.notify()

    def global_startup(current_state: ScheduleState):
        """Global startup broadcast"""

        current_state.info_lock.acquire()
        global_channel = current_state.info["global_channel"]
        current_state.info_lock.release()

        current_state.assign_publish(global_channel, StartupSignal().pack())
        current_state.notify()

    def schedule_tracker(current_state: ScheduleState, device_uuid):
        """Enforces schedule for a specific device"""

        current_state.info_lock.acquire()

        channel = current_state.info[device_uuid]["channel"]
        intervals = deepcopy(current_state.info[device_uuid]["schedule"])

        current_state.info_lock.release()

        intervals.sort(key = lambda i: f"{i[0]}{i[1]}")

        idx = 0
        hour = int(time.strftime("%H"), 10)
        delta = 0

        if hour > intervals[-1][0]:
            delta += 24 - hour
            hour = 0

        while intervals[idx][0] < hour:
            idx += 1
        delta += intervals[idx][0] - hour

        time.sleep(delta * SECONDS_PER_HOUR)

        while True:

            current_state.assign_publish(channel, StartupSignal().pack())
            time.sleep((intervals[idx][1] - intervals[idx][0]) * SECONDS_PER_HOUR)
            current_state.notify()

            current_state.assign_publish(channel, ShutdownSignal().pack())

            lo = intervals[idx][1]

            idx = (idx + 1) % len(intervals)
            hi = intervals[idx][0]

            delta = hi - lo
            if hi < lo:
                delta += 24

            time.sleep(delta * SECONDS_PER_HOUR)

    def power_schedule_tracker(current_state: ScheduleState, device_uuid):
        """Enforces ACPI schedule for a specific device"""

        current_state.info_lock.acquire()

        channel = current_state.info[device_uuid]["channel"]
        intervals = deepcopy(current_state.info[device_uuid]["power_schedule"])

        current_state.info_lock.release()

        intervals.sort(key = lambda i: f"{i[0]}{i[1]}")

        idx = 0
        hour = int(time.strftime("%H"), 10)
        delta = 0

        if hour > intervals[-1][0]:
            delta += 24 - hour
            hour = 0

        while intervals[idx][0] < hour:
            idx += 1
        delta += intervals[idx][0] - hour

        time.sleep(delta * SECONDS_PER_HOUR)

        while True:

            current_state.assign_publish(channel, SetEnergyLevelSignal(intervals[idx][3]).pack())
            time.sleep((intervals[idx][1] - intervals[idx][0]) * SECONDS_PER_HOUR)
            current_state.notify()

            current_state.assign_publish(channel, SetEnergyLevelSignal(intervals[idx][2]).pack())

            lo = intervals[idx][1]

            idx = (idx + 1) % len(intervals)
            hi = intervals[idx][0]

            delta = hi - lo
            if hi < lo:
                delta += 24

            time.sleep(delta * SECONDS_PER_HOUR)

    def alarm(current_state: ScheduleState,
              seconds, repeats, device_uuid,
              condition="always_true",
              content_generator="default_content"):
        """General-purpose alarm"""

        current_state.info_lock.acquire()
        channel = current_state.info[device_uuid]["channel"]
        current_state.info_lock.release()

        if repeats == -1:
            repeats = 1

        rep = 0
        while rep < repeats:

            time.sleep(seconds)

            if ScheduleHandlers.call[condition](current_state) is True:
                current_state.assign_publish(channel, ScheduleHandlers.call[content_generator](current_state))

            current_state.notify()

            if repeats == -1:
                rep += 1

    call = {
        "alarm": alarm,
        "schedule_tracker": schedule_tracker,
        "power_schedule_tracker": power_schedule_tracker,
        "global_shutdown": global_shutdown,
        "global_startup": global_startup,
        "always_true": lambda _: True,
        "default_content": lambda _: MqttMesssage(payload = f"ping {randint(0, 10000)}", sender = "sched").pack(),
        "ping_alive": lambda _: MqttMesssage(payload = f"ping {randint(0, 10000)}", sender = "sched").pack()
    }
    """Function dispatcher"""


class DeviceScheduler:
    """The mqtt client associated with the flask webserver\n
        It manages the current state of the devices and their scheduling"""

    def parse_device_settings(self, device, state: ScheduleState):
        """Update a state object based on given device settings"""

        settings = device.settings

        if "handlers" in settings.keys():
            for fct, kwargs in settings["handlers"].items():
                state.assign_exec_background(fct, kwargs)

        state.info[device.uuid] = {}

        if "channel" in settings.keys():
            state.info[device.uuid]["channel"] = settings["channel"]

        if "always_on" in settings.keys():
            state.info[device.uuid]["always_on"] = settings["always_on"]

        if "schedule" in settings.keys():
            state.info[device.uuid]["schedule"] = settings["schedule"]

        if "power_schedule" in settings.keys():
            state.info[device.uuid]["power_schedule"] = settings["power_schedule"]

    def scheduler_loop(self, state: ScheduleState):
        """Main scheduler infinite loop"""

        while True:

            # NOT busy waiting
            while len(state.queue) == 0:
                state.wakeup.acquire(True)  # only because the wait() call needs the current thread to have the lock
                state.wakeup.wait()

            while len(state.queue) > 0:

                r = state.queue.pop(0)

                if r[0] == ScheduleState.PUBLISH:
                    self.mqtt.publish(r[1], r[2])

                elif r[0] == ScheduleState.EXEC_SYNC:
                    ScheduleHandlers.call[r[1]](current_state=state, **r[2])

                elif r[0] == ScheduleState.EXEC_BACKGROUND:
                    thr = Thread(target=ScheduleHandlers.call[r[1]], daemon=True, args=(state,), kwargs=r[2])
                    thr.start()

    def start_scheduler(self):
        """Parses each device settings for each user, calls required handlers\n
            and then starts the (infinite) publisher loop, for each different user"""

        with self.app.app_context():
            for user in db.session.query(User).all():

                initial_state = ScheduleState()
                self.per_user_scheds[user] = Thread(target=self.scheduler_loop, daemon=True, args=(initial_state,))

                # NOTE: since the state object is currently referenced only here
                #       the locks are not (yet) used

                initial_state.assign_exec_sync("global_startup", {})

                for device in db.session.query(Device).filter_by(user_id=user.id):
                    self.parse_device_settings(device, initial_state)

                initial_state.info["global_channel"] = f"{self.config['global_channel_prefix']}_{user.id}"

                self.per_user_scheds[user].start()

    def __init__(self, app: Flask, config):

        self.config = config

        try:

            self.app = app
            self.mqtt = Mqtt(app)

            self.per_user_scheds = {}

            self.global_sched_thr = Thread(target=self.start_scheduler, daemon=True)
            self.global_sched_thr.start()

        except Exception as err:
            raise Exception(f"error while executing scheduler-related code: {err}")
