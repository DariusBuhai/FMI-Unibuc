from modules.news.news_sources import NewsFeed
import json
from modules.classifiers.h3_classifier import H3CLASSIFIER
import matplotlib.pyplot as plt


class StocksFeedClassification():

    def predict_headline(self, headline, likes, shares, news, tweets, stocks):
        H3C = H3CLASSIFIER(news, tweets, stocks["dates"], stocks["prices"])
        return H3C.create_prediction(headline, likes, shares)

    def relate_news_tweets_to_stocks(self, news, tweets, stocks):

        try:
            H3C = H3CLASSIFIER(news, tweets,stocks["dates"], stocks["prices"])
            dop = H3C.get_dict_of_points()

            v = []
            for x in dop:
                v += [(x, dop[x])]

            v.sort()

            dop2 = dict()
            dop2["rating"] = []
            dop2["stock"] = []

            for i in v:
                dop2["rating"] += [round(float(i[0]), 4)]
                dop2["stock"] += [float(i[1])]

            #plt.plot(dop2["rating"], dop2["stock"])
            #plt.show()

            return dop2

        except Exception as e:
            print(str(e))

        return []




