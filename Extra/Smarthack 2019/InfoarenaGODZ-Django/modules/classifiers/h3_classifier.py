#---------------------------------------------------------------------------------------------------------------------#
# Calculates the positivity coefficient of a piece of news or of a social media post

import json
import random
import math
import numpy as np
from numpy import *

import datetime

# Get the list o words we use form a database
temp_data = []
with open("modules/classifiers/dataset/database_words.json", "r") as read_file:
    temp_data =  json.load(read_file)

# Create the dict of words
# Create 2 dicts that count the number of occurrences of a word in positive/ negative sentences
words = {x : 0.0 for x in temp_data}
pos_count = {x : 0 for x in temp_data}
neg_count = {x : 0 for x in temp_data}

# Create the sentences dict
# The value of a sentence represent the coefficient of its positivity
sentences = dict()


# Process the negative sentences

neg_file = open("modules/classifiers/dataset/negative.txt", "r")

lim_max = 10 ** 50

for i in neg_file:
    # Get the words of the sentence

    s = str()

    # Each line ends in '.' thus the following algorithm works ( we do not need to check anything else )

    for j in i:
        if ('A' <= j <= 'Z') or ('a' <= j <= 'z'):
            s += j
        else:
            if s.lower() in words and len(s) >= 4:
                neg_count[s.lower()] += 1
            s = str()

# Process the positive sentences

pos_file = open("modules/classifiers/dataset/positive.txt", "r")

for i in pos_file:
    # Get the words of the sentence

    s = str()

    # Each line ends in '.' thus the following algorithm works ( we do not need to check anything else )

    for j in i:
        if ('A' <= j <= 'Z') or ('a' <= j <= 'z'):
            s += j
        else:
            if s.lower() in words and len(s) >= 4:
                pos_count[s.lower()] += 1
            s = str()

# Function that returns a 'much more random' positive number in range 1...log(max_range)
def get_random(max_range):
    return math.log( random.randint(3, max_range) ) * math.log( random.randint(3, max_range) )

random_constant = get_random(8)

# Calculate the positivity coefficient for each word by a given formula
for x in words:
    val = pos_count[x] - neg_count [x]
    if val != 0:
        words[x] = ( val // abs(val) )  * math.log( abs(val) )
    else:
        words[x] = 0


# Function that returns the coefficient of positivity of a word
def get_coef(_word):
    if _word.lower() in words:
        return words[_word.lower()]
    return 0

# Function that returns the coefficient of positivity of a sentence
def get_hash_sentence(sent):
    # add '.' at the end of the sentence for safety reasons
    sent += "."

    s = str()
    ans = 0
    for i in sent:
        if ('A' <= i <= 'Z') or ('a' <= i <= 'z'):
            s += i
        else:
            ans += get_coef(s)
            s = str()
    return ans

# Class for a piece of news
class Piece_of_news():
    def __init__(self, title, description, content):
        self.title = title
        self.description = description
        self.content = content

    def get_hash1(self):
        return get_hash_sentence(self.title) + (get_hash_sentence(self.description) / 2) + ( get_hash_sentence(self.content) / 3)

#-------------------------------------------------------------------------------------------------------------------------------------#

# Calculates the impact on social media of a tweet

# The impact of a post is calculated as follows:
    # sign( h1(text) ) * ( h1(post_text) ** h2(shares, likes) ) as the number of shares and likes is more relevant than the positivity coefficient

class Tweet():
    def __init__(self, text, no_likes, no_shares):
        self.text = text
        self.no_likes = no_likes
        self.no_shares = no_shares

    def get_hash2(self):

        max_tweets = 1e6
        max_range = 100

        val1 = get_hash_sentence(self.text)
        val2 = (self.no_likes + 1) * (self.no_shares + 1)
        if self.no_likes == self.no_shares and self.no_likes == 0:
            val2 = 0 # the post is completely irrelevant

        val2 = val2 * max_range / max_tweets # translate the value to the range [0, max_range]
        if val1 != 0:
            sgn = val1 // abs(val1) # the sign of val1
        else:
            sgn = 1

        if val2 == 0 and val1 == 0:
            val3 = 0 # the case 0 ** 0 may produce undefined behaviour
        else:
            val3 = ( ( 1 + abs(val1) ) ** val2 ).real * sgn # add 1 to the base for the hash function to be non-decreasing

        return val3

#----------------------------------------------------------------------------------------------------------------------------------------#

# For a day from the future for which we know the list of news and tweets, calculate the rating of that day
# Function that returns the rating of a day from the future
def new_rating(news, tweet):

    x = news.get_hash1()
    y = tweet.get_hash2()

    return x + 2 * y

#-----------------------------------------------------------------------------------------------------------------------------------------#

# Construct the interpolation polynomial of the set of points (x,y)
# where x is the rating of a company in a given day and y is the stock vlue in that day

def coeficiente(x,y) :
    ''' x: absisas x_i
        y : ordenadas f(x_i)'''

    x.astype(float)
    y.astype(float)
    n = len(x)
    F = np.zeros((n,n), dtype=float)
    b = np.zeros(n)
    for i in range(0,n):
        F[i,0]=y[i]



    for j in range(1, n):
        for i in range(j,n):
            F[i,j] = float(F[i,j-1]-F[i-1,j-1])/float(x[i]-x[i-j])


    for i in range(0,n):
        b[i] = F[i,i]

    return np.array(b) # return an array of coefficient

def eval(x, y, r):

    a = coeficiente(x, y)

    x.astype(float)
    n = len( a ) - 1
    temp = a[n]
    for i in range( n - 1, -1, -1 ):
        temp = temp * ( r - x[i] ) + a[i]
    return abs(temp) # return the y_value interpolation

#---------------------------------------------------------------------------------------------------------------------------------------------#

# Calculates the rating of a company in every day in which there was a piece of news or a social media post
# Calculates the price of a company's stock in every given day
# Calculates the price of the stock in each day, corresponding to the rating of that current day for the given company
# For a new date with a new set of news and social media make a prediction about the value of the stock in that given day

class H3CLASSIFIER():
    def __init__(self, news, tweets, stocks_dates, stocks_prices):

        # Hash1 - the positivity coefficient of a piece of news
        # Hash2 - the impact on social media of a social media post
        # S1(d) - the sum of Hash1(day) for all the news about the company in day 'd'
        # S2(d) - the sum of Hash2(day) for all the social media posts about the company in day 'd'
        # The rating of a company in a day is defined as S1(d) + 2 * S2(d) as the impact on social media counts more on the effect of the news on the company's stock

        #-------------------------------------------------------------------------

        #----------------- news ----------------- pair of score and date
        #----------------- tweets ---------------- pair of score and date
        #----------------- stocks----------------- set: list dates, list prices

        temp_news = news
        news = []

        for x in temp_news:
            v1 = x["Score"]
            w = x["publishedAt"]
            temp = str(datetime.datetime.strptime(w, "%Y-%m-%dT%H:%M:%SZ").date())
            v2 = int ( temp[8 : ] )
            news += [(v1, v2)]

        temp_tweets = tweets
        tweets = []

        for x in temp_tweets:
            v1 = x["Score"]
            w = str(x["date"])
            v2 = int ( w[ : 2] )
            tweets += [(v1, v2)]

        #---------------------------------------------------------------------------

        self.news = news
        self.tweets = tweets
        self.stocks_dates = stocks_dates
        self.stocks_prices = stocks_prices

        #self.news[]

    def get_dict_of_points(self):
        # Function that returns the price of the stock in each day, corresponding to the rating of that current day for the given company

        points1 = dict()
        points2 = dict()
        points3 = dict()

        # for the company store a pair (x,y) where x is a moment of time and y is the rating of the company in that moment of time ( points1 )
        # for the company store a pair (x,y) where x is a moment of time and y is the price of the company's stock in that moment of time ( points2 )
        # for the company store a pair (x,y) where x is the rating of the company in moment of time and y is the price of the company's stock in that moment of time ( points3 )

        # Calculate the sum of Hash1(day) for each day
        S1 = dict()
        for i in self.news:
            if i[1] in S1:
                S1[i[1]] += i[0]
            else:
                S1[i[1]] = i[0]

        # Calculate the sum of Hash2(day) for each day
        S2 = dict()
        for i in self.tweets:
            if i[1] in S2:
                S2[i[1]] += i[0]
            else:
                S2[i[1]] = i[0]

        # Calculate the rating of the company in each day

        for _day in S1:
            if _day in points1:
                points1[_day] += S1[_day]
            else:
                points1[_day] = S1[_day]
        for _day in S2:
            if _day in points2:
                points1[_day] += 2 * S2[_day]
            else:
                points1[_day] = 2 * S2[_day]

        # Calculate the price of the company's stock in eaach day

        dim_stocks = len(self.stocks_dates)
        for i in range(0,dim_stocks):
            if self.stocks_dates[i] in points2:
                points2[self.stocks_dates[i]] += self.stocks_prices[i]
            else:
                points2[self.stocks_dates[i]] = self.stocks_prices[i]

        # Calculate the price of the stock in each day, corresponding to the rating of that current day
        # If there are dates where there is information about the rating but there is no information about the stock,
        # we will consider the stock price equal to the one of the previous day that there is information for

        prev_stock_price = list(points2.values())[0]

        for _day in points1:
            val = prev_stock_price

            # If there is information about the stock price we save it in the variable val
            if _day in points2:
                val = points2[_day]

            points3[points1[_day]] = val
            prev_stock_price = val

        return points3

    # Function that predicts the expected value of the stock in a day from the future, knowing the news and social media posts from that day
    def make_prediction(self, new_news, new_tweets):
        # new_news is a list of news
        # new_tweets is a list of tweets
        wanted_point = new_rating(new_news, new_tweets)
        d = self.get_dict_of_points()
        x = np.array( list(d.keys()) )
        y = np.array( list(d.values()) )
        ans =  eval(x, y, wanted_point)
        maxx = max(d.values())
        while ans > maxx + 10:
            ans -= maxx
        return ans

    def create_prediction(self, headline, likes, shares):
        new_tweets = Tweet(headline, likes, shares)
        new_news = Piece_of_news("a", "a", "a")

        return round(self.get_perocentual_change(self.make_prediction(new_news,new_tweets)),3)

    # Function that calculates the average value of the stoke in the given period of time
    def get_average(self):
        sum = 0
        no = 0
        for i in self.stocks_prices:
            sum += i
            no += 1
        return sum / no

    # Function that returns the grow percentage of the stock
    def get_perocentual_change(self, new_y):
        med = self.get_average()
        diff = new_y - med
        return (diff / med) * 100