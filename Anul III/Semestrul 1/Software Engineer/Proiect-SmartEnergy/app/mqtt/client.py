import pickle
from random import randint
from threading import Thread

from paho.mqtt import client as mqtt_client

from app.models.device import Device
from app.mqtt.mqtt_message import MqttMesssage

class Client:
    """MQTT client serving as a (simulated) device mqtt endpoint\n
        It lightly wraps paho-mqtt client (raw client referenced with self.client attribute)"""

    def print(self, msg):
        print(f"[device {self.id}] {msg}")

    def on_connect(self, client, userdata, flags, rc):

        if rc == 0:
            self.print(f"connection established: status {rc}")
        else:
            self.print(f"connection failed: {rc}")

    def on_message(self, client, userdata, message: mqtt_client.MQTTMessage):
        self.print(f"Message on topic [{message.topic}] received: {pickle.loads(message.payload)}")

    def listener_loop(self):

        self.print(f"Starting to listen on channels [{self.global_channel, self.channel}] ...")
        
        try:
	
            self.client.connect(self.config["broker_addr"], self.config["broker_port"])
            self.client.subscribe([(self.global_channel, 0), (self.channel, 0)])
            
            self.client.loop_forever()

        except Exception as err:
            self.print(f"Exception while listening on channels [{self.global_channel, self.channel}]: {err}")

        except KeyboardInterrupt:

            self.print("Client unsubscribed, exiting...")
            self.client.unsubscribe([self.global_channel, self.channel])

    def start(self):
        self.listener.start()

    def __init__(self, config, device: Device):

        self.config = config

        self.device = device
        self.name = self.device.alias[:-5]
        self.id = f"{self.name}_{randint(0, 0xffffffff)}"

        self.global_channel = f"{self.config['global_channel_prefix']}_{self.device.user_id}"
        self.channel = self.device.settings["channel"]

        self.client = mqtt_client.Client(self.id)

        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        self.listener = Thread(target = self.listener_loop, daemon = True)
