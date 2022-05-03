from blockchain import Blockchain
from uuid import uuid4


class Miner(Blockchain):
    def __init__(self):
        super().__init__()
        self.miner_id = str(uuid4()).replace('-', '')
        self.miners = Blockchain.FRIENDLY_MINERS

    def mine(self):
        print("Started mining")
        lastBlock = self.blockchain[-1]
        lastBlockHash = Blockchain.hashBlock(lastBlock)
        # we add our reward
        self.appendTransaction(Blockchain.MINER_ADDRESS, self.miner_id, Blockchain.MINER_REWARD, signature=None)
        nonce = Blockchain.PoW(lastBlockHash, self.transactions_pool)
        print(f"Determined nonce: {nonce}")
        block = self.appendBlock(nonce, lastBlockHash)
        print(f"Appended block to blockchain: {block}")

    def runMiner(self):
        self.resolveConflicts()
        if len(self.transactions_pool) != 0:
            self.mine()
            return True
        return False
