import json

from flask import Flask

from app.mqtt.broker import Broker
from app.mqtt.device_scheduler import DeviceScheduler
from app.mqtt.client import Client
from app.models.user import User
from app.models.device import Device
from app.models.db import db

MQTT_CONFIG_PATH = "./app/mqtt/mqtt_config.json"


class MqttHub:
    """A class that contains most of mqtt-related initialization and runtime management\n"""

    handle = None

    @staticmethod
    def load_config(path):
        with open(path, "r") as f:
            return json.load(f)

    @staticmethod
    def update_config(path, new_config):
        with open(path, "w+") as f:
            json.dump(new_config, f)

    def __init__(self, app: Flask, config_path):

        self.config_path = config_path
        self.config = MqttHub.load_config(config_path)

        app.config['MQTT_BROKER_URL'] = self.config["broker_addr"]
        app.config['MQTT_BROKER_PORT'] = self.config["broker_port"]
        app.config['MQTT_USERNAME'] = self.config["mqtt_username"] 
        app.config['MQTT_PASSWORD'] = self.config["mqtt_pass"] 
        app.config['MQTT_KEEPALIVE'] = self.config["mqtt_keepalive"] 
        app.config['MQTT_TLS_ENABLED'] = self.config["tls_enabled"]

        self.broker = Broker(self.config)
        self.scheduler = None  # later

        self.app = app

        self.clients = {}

    def create_client(self, name, user_id) -> Client:
        """Adds a client (currently simulated) endpoint"""

        device = db.session.query(Device).filter_by(alias=name, user_id=user_id).first()

        self.clients.update({name: Client(self.config, device)})
        return self.clients[name]

    def initialize_scheduler(self):
        """initialize (and start) the scheduler,\
            which, in turn, executes device initialization handlers, \
            and enforces per-device schedule"""

        self.scheduler = DeviceScheduler(self.app, self.config)

    def watch_clients(self):
        """Emulate device I/O"""

        with self.app.app_context():
            for user in db.session.query(User).all():

                for device in db.session.query(Device).filter_by(user_id=user.id):
                    self.create_client(device.alias, device.user_id)

        for client in self.clients.values():
            client.start()

def initiateMqtt(app):
    MqttHub.handle = MqttHub(app, MQTT_CONFIG_PATH)
    return MqttHub.handle
