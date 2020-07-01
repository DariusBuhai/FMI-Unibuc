from hashlib import sha256
from pathlib import Path

class RaibowDeck:

    __rainbow = {}

    def __init__(self, path = None):
        if path:
            self.load(path)

    def load(self, path):
        t = Path(path).read_text().split('\n')
        self.__rainbow = {sha256(p.encode()).hexdigest() : p for p in t}

    def get(self):
        return self.__rainbow

    def find_password(self, hash):
        if hash in self.__rainbow:
             return self.__rainbow[hash]
        return None

