from modules.news.news_sources import NewsFeed
import json
from modules.classifiers.h1_classifier import H1CLASSIFIER
from modules.classifiers.h2_classifier import H2CLASSIFIER

class NewsFeedClassification():

    def classify_news_by_company(company):

        return 0

    def classify_news(self, news):

        index = 0
        news2 = []
        for new in news:
            # use hash 1 classifier to add rating to the news
            if new["title"]!=None and new["description"]!=None and new["content"]!=None:
                PN = H1CLASSIFIER(new["title"], new["description"], new["content"])
                new["Score"] = PN.get_hash1()
                news2 += [new]

        return news2

    def classify_tweets(self, tweets):

        index = 0
        for tweet in tweets:
            # use hash 1 classifier to add rating to the news
            PN = H2CLASSIFIER(tweet["text"], tweet["shares"], tweet["likes"])
            tweets[index]["Score"] = PN.get_hash2()
            index+=1

        return tweets

    def relate_news_to_stocks(self, news, stocks):

        news = self.classify_news(news) # apply rating to news



