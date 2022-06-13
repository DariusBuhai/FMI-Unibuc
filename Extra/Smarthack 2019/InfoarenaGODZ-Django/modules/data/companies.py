import json
from modules.stocks.company_stocks import StockFeed

class DataCompanies():

    def get_companies():
        try:
            with open("data/companies.json", "r") as c:
                companies = json.loads(c.read())
                index = 0
                for company in companies:
                    SF = StockFeed()
                    sfs = SF.get_company_stock(company["code"])
                    med = 0
                    ind = 0
                    for i in sfs['prices']:
                        ls = i
                        med+=i
                        ind+=1
                    med = med/ind
                    companies[index]["last_stock"] = ls
                    companies[index]["medium_stock"] = round(med, 3)
                    index += 1
                return companies
        except Exception:
            return Exception

