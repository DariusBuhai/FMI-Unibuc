import numpy as np
from modules.trading_environment import TradingEnv, Actions
from modules.wordprocessing import WordProcessing
from collections import deque


class StocksNewsEnv(TradingEnv):

    def __init__(self, stocks_df, news_df, bao, window_size, frame_bound, initial_balance=1000):
        assert len(frame_bound) == 2

        self.frame_bound = frame_bound
        super().__init__(stocks_df=stocks_df, news_df=news_df, bao=bao, window_size=window_size,
                         initial_balance=initial_balance)

        self.trade_fee_bid_percent = 0.01
        self.trade_fee_ask_percent = 0.005

    # TODO: Adapt and modify features
    # Current features: (36) -> [price - size(5), bag of words - size(30), sentimental analysis = size(2)]
    def _process_data(self):
        # Prices
        prices = self.stocks_df.loc[:, 'Close'].to_numpy()
        prices = prices[self.frame_bound[0] - self.window_size:self.frame_bound[1]]

        price_features = []
        for idx in range(self.frame_bound[0], self.frame_bound[1]):
            if idx < 2 * self.window_size:
                #  Not enough data.
                #  Does not really matter, this happens very few times.
                price_features.append([0 for _ in range(2 * self.window_size - 1)])
            else:
                prices_current = prices[idx - 2 * self.window_size + 1: idx]
                prices_prev = prices[idx - 2 * self.window_size: idx - 1]
                diff_prices = prices_current - prices_prev
                price_features.append(diff_prices)

        price_features = np.array(price_features)

        # Articles features - not used for the moment
        # trade_days = [x.strftime("%Y-%m-%d") for x in
        #               list(self.stocks_df.loc[:, 'Date'][self.frame_bound[0]:self.frame_bound[1]])]
        # articles = []
        # for trade_day in trade_days:
        #     if trade_day in self.news_df.keys():
        #         articles.append(self.news_df[trade_day]['articles'])
        #     else:
        #         articles.append([])
        # article_features = []
        #
        # for day in articles:
        #     words_usages, sentimental_analysis = np.zeros(30), np.zeros(2)
        #     for article in day:
        #         words_usages = np.add(words_usages, WordProcessing.getWordsUsages(self.bao, article))
        #         sentimental_analysis = np.add(sentimental_analysis, WordProcessing.getSentimentalAnalysis(article))
        #     article_features.append(np.concatenate((words_usages, sentimental_analysis)))
        # article_features = np.array(article_features)
        # Concatenate features
        features = price_features
        return prices, features

    def _calculate_reward(self, action, actual_action):
        if self._current_tick == self._end_tick:
            return 0

        next_day_price = self.prices[self._current_tick + 1]
        current_price = self.prices[self._current_tick]

        if action == Actions.Buy.value:
            if next_day_price > current_price:
                return 0.6
            else:
                return -1
        elif action == Actions.Sell.value:
            if next_day_price > current_price:
                return -1
            else:
                return 1
        else:
            if self._shares >= 1 and current_price < next_day_price:
                #  Ar fi fost bine sa vanda
                return -0.8
            elif self._balance > current_price + 1 and current_price < next_day_price:
                #  Ar fi fost bine sa cumpere
                return -0.2
            return 1

    def _update_profit(self, action):
        current_price = self.prices[self._current_tick]

        # Update balance and shares
        final_action = Actions.Hold.value
        if action == Actions.Buy.value:
            shares_to_buy = min(self._max_buy, self._balance) * (1 - self.trade_fee_ask_percent) / current_price
            if shares_to_buy > 0.1:
                self._last_balance = self._balance
                self._balance -= current_price * shares_to_buy
                self._shares += shares_to_buy
                final_action = Actions.Buy.value
        if action == Actions.Sell.value:
            shares_to_sell = min(2, self._shares)
            if shares_to_sell > 0:
                self._last_balance = self._balance
                self._balance += current_price * shares_to_sell
                self._shares -= shares_to_sell
                final_action = Actions.Sell.value

        self._total_profit = (self._balance + self._shares * current_price) - self._initial_balance
        return final_action

    def max_possible_profit(self):
        current_tick = self._start_tick
        profit = 0

        while current_tick <= self._end_tick:
            if self.prices[current_tick] < self.prices[current_tick - 1]:
                while (current_tick <= self._end_tick and
                       self.prices[current_tick] < self.prices[current_tick - 1]):
                    current_tick += 1
            else:
                while (current_tick <= self._end_tick and
                       self.prices[current_tick] >= self.prices[current_tick - 1]):
                    current_tick += 1

        return profit
