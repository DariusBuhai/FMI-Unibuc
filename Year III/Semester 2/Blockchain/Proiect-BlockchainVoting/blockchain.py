import hashlib
import json
from os.path import exists
from time import time
from urllib.parse import urlparse

import requests
from Crypto.Hash import SHA
from Crypto.PublicKey import RSA
from Crypto.Signature import PKCS1_v1_5
import binascii

VOTING_OPTIONS = [
    "Blockchain",
    "NLP",
    "iOS",
    "Android",
    "PAS",
    "Computer Vision"
]

ADMIN_PUBLIC_KEY = "30819f300d06092a864886f70d010101050003818d0030818902818100ead08f972b7a6b723fc3dac52c3da01efb0054a1f2f876de38f96d577b46d598dd82993800f3188a065d94ecc2e7aea72267bfc0c5af02c51c249720f158308a3d6db563b7e67228fdc8928dd7f7f638c1c525813d94125140d9fc561a244f618070aefaa6b027de3a644327cacc153f82159e61977ca30db6ccc0baea4c9a770203010001"


class Blockchain:
    MINING_DIFFICULTY = 2
    MINER_ADDRESS = "MINER_ADDRESS"
    MINER_REWARD = 1
    FRIENDLY_MINERS = ['127.0.0.1:9000']

    def __init__(self):
        self.blockchain = None
        self.transactions_pool = []
        self.loadBlockchain()
        self.miners = set()

    # Useful static methods
    @staticmethod
    def hash(s):
        return hashlib.sha256(s).hexdigest()

    @staticmethod
    def hashBlock(block):
        return Blockchain.hash(json.dumps(block, sort_keys=True).encode())

    @staticmethod
    def verifyPoW(transactions_pool, last_hash, nonce):
        guess = Blockchain.hash(
            f"{json.dumps(transactions_pool, sort_keys=True)}{last_hash.__str__()}{nonce.__str__()}".encode())
        return guess[:Blockchain.MINING_DIFFICULTY] == '0' * Blockchain.MINING_DIFFICULTY

    @staticmethod
    def getBlockchainAvailableFunds(blockchain):
        available_funds = dict()
        for i in range(1, len(blockchain)):
            block = blockchain[i]
            block_transactions = block['transactions']
            for transaction in block_transactions:
                if transaction['sender'] in available_funds:
                    available_funds[transaction['sender']] -= transaction['value']
                if transaction['receiver'] in available_funds:
                    available_funds[transaction['receiver']] += transaction['value']
                else:
                    available_funds[transaction['receiver']] = transaction['value']
        return available_funds

    @staticmethod
    def verifyBlockchain(blockchain):
        if len(blockchain) <= 1:
            return True
        available_funds = dict()
        for i in range(1, len(blockchain)):
            block = blockchain[i]
            if block["lastHash"] != Blockchain.hashBlock(blockchain[i - 1]):
                return False
            block_transactions = block['transactions']

            if not Blockchain.verifyPoW(block_transactions, block["lastHash"], block["pow"]):
                print(f"Invalid Proof of work for node: {i}")
                return False

            # Verify transactions
            for transaction in block_transactions:
                if transaction['sender'] not in [ADMIN_PUBLIC_KEY, Blockchain.MINER_ADDRESS]:
                    if available_funds[transaction['sender']] < transaction['value']:
                        return False
                    available_funds[transaction['sender']] -= transaction['value']
                if transaction['receiver'] in available_funds:
                    available_funds[transaction['receiver']] += transaction['value']
                else:
                    available_funds[transaction['receiver']] = transaction['value']

        return True

    @staticmethod
    def verifyTransactionSignature(sender, signature, transaction):
        pk = RSA.importKey(binascii.unhexlify(sender))
        verifier = PKCS1_v1_5.new(pk)
        h = SHA.new(json.dumps(transaction, sort_keys=True).encode('utf8'))
        return verifier.verify(h, binascii.unhexlify(signature))

    # Load and save transactions and blockchain
    def loadBlockchain(self):
        self.blockchain = []
        if exists("data/blockchain.json"):
            with open("data/blockchain.json", "r") as f:
                self.blockchain = json.loads(f.read())

        # Append initial block if non existent
        if len(self.blockchain) == 0:
            self.appendBlock(0, "00")

    def saveBlockchain(self):
        with open("data/blockchain.json", "w") as f:
            f.write(json.dumps(self.blockchain))

    def appendBlock(self, nonce, last_hash):
        block = {
            "id": len(self.blockchain),
            "timestamp": time(),
            "lastHash": last_hash,
            "pow": nonce,
            "transactions": self.transactions_pool
        }
        self.blockchain.append(block)
        self.transactions_pool = []
        if not self.verifyBlockchain(self.blockchain):
            self.blockchain.remove(block)
            return None
        self.saveBlockchain()
        return block

    def appendTransaction(self, sender, receiver, value, signature):
        transaction = {
            "sender": sender,
            "receiver": receiver,
            "value": int(value)
        }
        if sender != Blockchain.MINER_ADDRESS and not self.verifyTransactionSignature(sender, signature, transaction):
            return False, "Invalid transaction"
        availableFunds = self.getBlockchainAvailableFunds(self.blockchain)
        if sender not in [ADMIN_PUBLIC_KEY, self.MINER_ADDRESS] and (
                sender not in availableFunds or availableFunds[sender] < int(value)):
            return False, "Insufficient funds"

        self.transactions_pool.append(transaction)
        return len(self.blockchain) + 1, "OK"

    @staticmethod
    def PoW(lastBlockHash, transactionPool):
        nonce = 0
        while not Blockchain.verifyPoW(transactionPool, lastBlockHash, nonce):
            nonce += 1
        return nonce

    # Manage miners
    def registerMiner(self, url):
        pu = urlparse(url)
        if pu.netloc:
            self.miners.add(pu.netloc)
        elif pu.path:
            self.miners.add(pu.path)

    def resolveConflicts(self):
        max_chain_length = len(self.blockchain)
        new_blockchain = None

        for node in self.miners:
            try:
                response = requests.get('http://' + node + '/get/blockchain')
                if response.status_code == 200:
                    json_resp = response.json()
                    length = json_resp['length']
                    blockchain = json_resp['chain']
                    if length > max_chain_length and self.verifyBlockchain(blockchain):
                        max_chain_length = length
                        new_blockchain = blockchain
            except:
                pass

        if new_blockchain is not None:
            self.blockchain = new_blockchain
            self.saveBlockchain()
            return True
        return False
