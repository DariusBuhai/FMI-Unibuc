import binascii

import Crypto
import Crypto.Random
from Crypto.Hash import SHA
from Crypto.PublicKey import RSA
from Crypto.Signature import PKCS1_v1_5
import json
import requests
from blockchain import Blockchain


class Client:
    def __init__(self, private_key=None, public_key=None):
        if private_key is None:
            random_gen = Crypto.Random.new().read
            private_key = RSA.generate(1024, random_gen)
            public_key = private_key.publickey()
            self.private_key = binascii.hexlify(private_key.exportKey(format='DER')).decode('ascii')
            self.public_key = binascii.hexlify(public_key.exportKey(format='DER')).decode('ascii')
        else:
            self.private_key = private_key
            self.public_key = public_key

    @staticmethod
    def signTransaction(transaction, private_key):
        private_key = RSA.importKey(binascii.unhexlify(private_key))
        signer = PKCS1_v1_5.new(private_key)
        h = SHA.new(json.dumps(transaction, sort_keys=True).encode('utf8'))
        return binascii.hexlify(signer.sign(h)).decode('ascii')

    @staticmethod
    def getAvailableFunds(address):
        try:
            response = requests.get(f"http://{Blockchain.FRIENDLY_MINERS[0]}/get/available_funds/{address}")
            return response
        except Exception:
            return None

    def createTransaction(self, receiver, value=1):
        transaction = {
            'sender': self.public_key,
            'receiver': receiver,
            'value': value
        }
        signature = self.signTransaction(transaction, self.private_key)
        data_to_send = transaction
        data_to_send['signature'] = signature
        response = requests.post(f"http://{Blockchain.FRIENDLY_MINERS[0]}/transactions/new", data=transaction)
        return response
