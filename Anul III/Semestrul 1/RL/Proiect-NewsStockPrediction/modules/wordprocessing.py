from typing import List

from modules.news import News


class WordProcessing(News):
    def getBagOfWords(self):
        useless_words = [self.KEYWORDS[self.stock].lower(), self.stock.lower(), "to", "for", "-", "and", "", "the",
                         "are", "has", "chars]", "that", "from", "with", "have", "its", "was", "(Reuters)"]
        bao = dict()
        for day in self.news_per_days.keys():
            if "articles" not in self.news_per_days[day]:
                continue
            for article in self.news_per_days[day]['articles']:
                if 'content' in article:
                    for word in article['content'].split():
                        if word.lower() in useless_words or len(word) < 3:
                            continue
                        if word not in bao.keys():
                            bao[word] = 1
                        else:
                            bao[word] += 1
        words_used = list()
        for word in bao:
            words_used.append((word, bao[word]))
        words_used.sort(key=lambda x: x[1], reverse=True)
        return words_used

    def getMostUsedWords(self, limit=30):
        words_used = self.getBagOfWords()
        return [x[0] for x in words_used[:limit]]

    @staticmethod
    def getWordsUsages(bao: List[str], article):
        words_usages = dict()
        for word in bao:
            words_usages[word] = 0

        def getWordsUsedIn(text):
            for word in text.split():
                if word in words_usages.keys():
                    words_usages[word] += 1

        if 'content' in article:
            getWordsUsedIn(article['content'])
        if 'title' in article:
            getWordsUsedIn(article['title'])
        return list(words_usages.values())

    @staticmethod
    def getSentimentalAnalysis(article):
        positive_words_set, negative_words_set = set(), set()
        with open("data/positive-words.txt") as pw:
            positive_words = pw.read().split()
            for word in positive_words:
                positive_words_set.add(word)
        with open("data/negative-words.txt") as nw:
            negative_words = nw.read().split()
            for word in negative_words:
                negative_words_set.add(word)

        positive_score, negative_score = 0, 0

        def getSentimentalScore(text, positive_score, negative_score):
            for word in text.split():
                if word in positive_words_set:
                    positive_score += 1
                elif word in negative_words_set:
                    negative_score += 1
            return positive_score, negative_score

        if 'content' in article:
            positive_score, negative_score = getSentimentalScore(article['content'], positive_score, negative_score)
        if 'title' in article:
            positive_score, negative_score = getSentimentalScore(article['title'], positive_score, negative_score)

        return [positive_score, negative_score]


if __name__ == '__main__':
    word_processing = WordProcessing("PFE")
    bao = word_processing.getBagOfWords()
    print(bao[:30])
