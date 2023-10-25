import pickle

class MqttMesssage:
    """Wrapper for mqtt API messages"""

    def __init__(self, payload = b"",
                        sender = None,
                        urgent = False,
                        flags = b""):
        
        self.sender = sender
        self.urgent = urgent
        self.flags = flags
        self.payload = payload

    @staticmethod
    def unpack(self, b):
        return pickle.loads(b)

    def pack(self) -> bytes:
        return pickle.dumps(self)

    def __repr__(self):
        return f"[MQTT ({'non-urgent' if self.urgent else 'urgent'})" + \
                    f" message (sender: {self.sender}, flags {self.flags}): {self.payload}]"

class ShutdownSignal(MqttMesssage):
    """Equivalent to ACPI level D3 hot"""

    def __init__(self, urgent = False):
        super(ShutdownSignal, self).__init__(payload = b"<<SHUTDOWN>>", sender = b"sched", urgent = urgent, flags = b"")

class StartupSignal(MqttMesssage):
    """Equivalent to ACPI level D0"""

    def __init__(self, urgent = False):
        super(StartupSignal, self).__init__(payload = b"<<START>>", sender = b"sched", urgent = urgent, flags = b"")

class SetEnergyLevelSignal(MqttMesssage):

    def __init__(self, urgent = False, level = "D0"):
        super(SetEnergyLevelSignal, self).__init__(payload = b"<<POWER>>", sender = b"sched", urgent = urgent, flags = level.encode())

        assert(level in ["D0", "D1", "D2", "D3HOT", "D3COLD"])
        