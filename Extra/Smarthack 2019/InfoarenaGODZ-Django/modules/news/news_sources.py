from newsapi import NewsApiClient
import requests
import json
from datetime import datetime
from modules.stocks.company_stocks import StockFeed

API_KEY = '2fdb18e9297a437ab91a7ec7669bed35'
newsapi = NewsApiClient(api_key=API_KEY)

class NewsFeed():

    def get_company_news(company = ""):

        URL = "https://newsapi.org/v2/everything"

        # defining a params dict for the parameters to be sent to the API
        PARAMS = {'apiKey': 'f0841974977e41febb90d6f83837435f',
                  'q' : company,
                  'sortBy':'popularity'}

        # sending get request and saving the response as response object
        r = requests.get(url=URL, params=PARAMS)

        # extracting data in json format
        data = r.json()
        return data

    def get_twitter_news(company_s):

        # Not allowed to get real tweets, might fix in the future when I receive an email ;)
        #URL = "https://api.twitter.com/1.1/search/tweets.json"
        # defining a params dict for the parameters to be sent to the API
        #PARAMS = {'apiKey': '2fdb18e9297a437ab91a7ec7669bed35',
                  #'q': company,
                  #'sortBy': 'popularity'}
        # sending get request and saving the response as response object
        #r = requests.get(url=URL, params=PARAMS)
        # extracting data in json format
        #data = r.json()

        SF = StockFeed()
        stocks = SF.get_company_stock(company_s)

        with open("data/tweets.json") as p:
            p = json.load(p)
            p = p[company_s]
            index1 = 0
            for tweet in p:
                day1 = datetime.strptime(tweet["date"], "%d-%m-%Y").date().day
                index = 0
                p[index1]["stoc_price"] = 0
                for day2 in stocks["dates"]:
                    if day2==day1:
                        p[index1]["stoc_price"] = stocks["prices"][index]
                    index+=1

        return p