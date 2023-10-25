from modules.environment import StocksNewsEnv
from modules.model import DeepLearningModel
import pandas as pd

from modules.wordprocessing import WordProcessing


class Agent(WordProcessing):
    STOCKS_PATH = "data/stocks/"
    TRAIN_SIZE = 100

    def __init__(self, stock):
        super().__init__(stock)
        self.bao = self.getMostUsedWords()
        self.df = pd.read_csv(f'{self.STOCKS_PATH}{stock}.csv')
        self.df['Date'] = pd.to_datetime(self.df['Date'])
        self.df.sort_values('Date')
        self.env = StocksNewsEnv(stocks_df=self.df, news_df=self.news_per_days, bao=self.bao, frame_bound=(5, self.df.shape[0]-self.TRAIN_SIZE), window_size=5)
        self.model = DeepLearningModel(self.env)

    def test(self):
        self.env.action_spacestate = self.env.reset()
        while True:
            action = self.env.action_space.sample()
            n_state, reward, done, info = self.env.step(action)
            if done:
                print("info", info)
                break
        self.show()

    def show(self):

        self.model.env.render_all()

    def train(self, verbose=1, steps=100):
        self.model.verbose = verbose
        self.model.learn(total_timesteps=steps)

    def evaluate(self):
        self.env = StocksNewsEnv(stocks_df=self.df, news_df=self.news_per_days, bao=self.bao, frame_bound=(5, self.df.shape[0]-self.TRAIN_SIZE),
                                 window_size=5)
        self.model.update_env(self.env)
        print('Evaluare noua')
        self.model.evaluate()
