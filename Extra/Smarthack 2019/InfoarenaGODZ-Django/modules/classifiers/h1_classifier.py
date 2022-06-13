# Calculates the positivity coeficient of a piece of news

import json
import random
import math

temp_data = []
with open("modules/classifiers/dataset/database_words.json", "r") as read_file:
    temp_data =  json.load(read_file)

# Create the dict of words
# Create 2 dicts that count the number of occurences of a word in positive/ negative sentences
words = {x : 0.0 for x in temp_data}
pos_count = {x : 0 for x in temp_data}
neg_count = {x : 0 for x in temp_data}

# Create the sentences dict
# The value of a sentence represent a coeficient of its positivity
sentences = dict()


# Process the negative sentences

neg_file = open("modules/classifiers/dataset/negative.txt", "r")

lim_max = 10 ** 50

for i in neg_file:
    # Get the words of the sentence

    s = str()

    # Each line ends in '.' thus the following algorithm works

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

    # Each line ends in '.' thus the following algorithm works

    for j in i:
        if ('A' <= j <= 'Z') or ('a' <= j <= 'z'):
            s += j
        else:
            if s.lower() in words and len(s) >= 4:
                pos_count[s.lower()] += 1
            s = str()

# Function that returns a 'much random' positive number in range 1...log(max_range)
def get_random(max_range):
    return math.log( random.randint(3, max_range) ) * math.log( random.randint(3, max_range) )

random_constant = get_random(8)
for x in words:
    val = pos_count[x] - neg_count [x]
    if val != 0:
        words[x] = ( val // abs(val) )  * math.log( abs(val) )
    else:
        words[x] = 0


# Function that retuns the coeficint of positivity of a word
def get_coef(_word):
    if _word.lower() in words:
        return words[_word.lower()]
    return 0

# Function that retuns the coeficint of positivity of a sentence
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

class H1CLASSIFIER():
    def __init__(self, title, description, content):
        self.title = title
        self.description = description
        self.content = content

    def get_hash1(self):
        return get_hash_sentence(self.title) + (get_hash_sentence(self.description) / 2) + ( get_hash_sentence(self.content) / 3)