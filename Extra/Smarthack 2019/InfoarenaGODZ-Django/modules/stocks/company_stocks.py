import requests
import json
import matplotlib.pyplot as plt
from datetime import datetime

def get_company_stock(company_smb):
    URL = "https://www.alphavantage.co/query"
    PARAMS = {'apikey': 'R1C0A37LIQEXRV8A',
              'function': 'TIME_SERIES_DAILY_ADJUSTED',
              'symbol': company_smb}
    r = requests.get(url=URL, params=PARAMS)
    return r.json()

def save_company_stock(id):
    # Limited requests 500 due to demo app
    with open("data/companies.json") as c:
        companies = json.load(c)
    stock = get_company_stock(companies[id]["code"])
    print(stock)
    with open("data/stocks.json", "r") as a:
        r = json.load(a)
        r[companies[id]["code"]] = stock

    with open("data/stocks.json", "w") as b:
        json.dump(r, b)



class StockFeed():

    def get_company_stock(self, company_smb):

        #save_company_stock(4)

        with open("data/stocks.json", "r") as a:
            r = json.load(a)
        r = r[company_smb]

        try:
            dates = []
            prices = []
            for x in r["Time Series (Daily)"]:
                datex = datetime.fromisoformat(x)
                if datex.month==10 and datex.year==2019:
                    dates += [datex.day]
                    prices += [float(r["Time Series (Daily)"][x]["1. open"])]
            dates.reverse()
            prices.reverse()
            # Show graph for debug only
            #plt.plot(dates, prices)
            #plt.show()

            #plt.savefig('data/foo.png')

            return {"dates":dates, "prices":prices}
        except Exception as e:
            print(str(e))

        return r


