from tensorflow import keras

from modules.agent import Agent
import os

if __name__ == "__main__":
    os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
    agent = Agent("VOO")
    print(agent.env.signal_features)

    # for _ in range(10):
    #     agent.model.load_best()
    #     agent.train(steps=100)
    #     agent.show()
