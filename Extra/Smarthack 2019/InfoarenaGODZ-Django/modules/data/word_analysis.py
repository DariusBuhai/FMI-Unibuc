import json

class DataCompanies():

    def get_word_analysis():
        try:
            with open("data/word_analysis.json", "r") as c:
                return json.loads(c.read())
        except Exception:
            return Exception

