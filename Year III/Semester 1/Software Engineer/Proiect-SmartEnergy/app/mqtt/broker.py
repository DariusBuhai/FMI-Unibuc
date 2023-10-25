import sys
from subprocess import Popen
from time import sleep


class Broker:
    START_DELAY = 0.5

    def __init__(self, config):

        try:
            cmd = "C:\\Program Files\\mosquitto\\mosquitto.exe" if sys.platform == "win32" else "mosquitto"

            self.broker_proc = Popen([cmd, "-p", f"{config['broker_port']}"])
            sleep(Broker.START_DELAY)

        except Exception as err:
            raise Exception(f"could not initialize mqtt broker: {err}")
