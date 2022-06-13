import json
import os.path

import requests
from datetime import date, timedelta

NEWS_URI = "https://newsapi.org/v2/everything"
NEWS_API_KEY = "2fdb18e9297a437ab91a7ec7669bed35"
NEWS_SOURCES = ""


class News:

    NEWS_PATH = "data/news/"

    KEYWORDS = {
        "PATH": "UiPath",
        "MDRN": "Moderna",
        "PFE": "Pfizer",
        "VOO": "Vanguard S&P",
    }

    def __init__(self, stock):
        self.news_per_days = dict()
        self.stock = stock
        self.loadNews()

    def getNewsFromApi(self, interval=None):
        keyword = self.KEYWORDS[self.stock]
        if not interval:
            interval = (date.today(), date.today())
        # defining a params dict for the parameters to be sent to the API
        PARAMS = {'apiKey': NEWS_API_KEY,
                  'qInTitle': keyword,
                  'language': "en",
                  'sortBy': 'relevancy',
                  'from': str(interval[0]),
                  'to': str(interval[1])}

        # sending get request and saving the response as response object
        r = requests.get(url=NEWS_URI, params=PARAMS)

        # extracting data
        return r.json()

    def categorizeNewsPerDays(self, interval=None):
        if not interval:
            interval = (date.today(), date.today())
        current_day = interval[1]
        print("Loading news: ")
        while current_day >= interval[0]:
            if str(current_day) not in self.news_per_days.keys():
                self.news_per_days[str(current_day)] = self.getNewsFromApi((current_day, current_day))
            current_day -= timedelta(days=1)
            print("#", end="")
        print("\nDone.")

    def saveNews(self):
        self.categorizeNewsPerDays((date.today() - timedelta(days=31), date.today()))
        filepath = f"{self.NEWS_PATH}{self.stock}.json"
        with open(filepath, "w") as f:
            f.write(json.dumps(self.news_per_days))
        print(f"News saved to {filepath}")

    def loadNews(self):
        # TODO: Process each news using wordprocessing
        filepath = f"{self.NEWS_PATH}{self.stock}.json"
        if os.path.exists(filepath):
            with open(filepath, "r") as r:
                self.news_per_days = json.loads(r.read())


if __name__ == '__main__':
    news = News("MDRN")
    news.saveNews()
