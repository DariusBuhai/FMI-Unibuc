from nltk.stem.porter import *
import re
import numpy as np


def preprocessDataset(dataset):
    def removePattern(input_txt, pattern):
        r = re.findall(pattern, input_txt)
        for j in r:
            input_txt = re.sub(re.escape(j), '', input_txt)
        return input_txt

    # remove @user
    dataset['tweet'] = np.vectorize(removePattern)(dataset['tweet'], "@[\w]*")

    # remove URL
    dataset['tweet'] = np.vectorize(removePattern)(
        dataset['tweet'], "https?://[\S]+")
    dataset['tweet'] = np.vectorize(removePattern)(
        dataset['tweet'], "http?://[\S]+")

    # remove Punctuations, Numbers, and Special Characters
    dataset['tweet'] = dataset['tweet'].str.replace("[^a-zA-Z#]", " ")

    # remove Short Words
    dataset['tweet'] = dataset['tweet'].apply(
        lambda x: ' '.join([w for w in x.split() if len(w) > 3]))

    # Convert to lower case
    dataset['tweet'] = dataset['tweet'].apply(
        lambda x: ' '.join([x.lower()]))

    # Convert more than 2 letter repetitions to 2 letter
    dataset['tweet'] = dataset['tweet'].apply(lambda x: ' '.join([re.sub(r'(.)\1+', r'\1\1', x)]))

    # Replaces #hashtag with hashtag
    dataset['tweet'] = dataset['tweet'].apply(lambda x: ' '.join([re.sub(r'#(\S+)', r' \1 ', x)]))

    # Replace multiple spaces with a single space
    dataset['tweet'] = dataset['tweet'].apply(
        lambda x: ' '.join([re.sub(r'\s+', ' ', x)]))

    # test text Normalization
    tokenized_test = dataset['tweet'].apply(lambda x: x.split())  # tokenizing

    # normalize the tokenized tweets.
    stemmer = PorterStemmer()
    tokenized_test = tokenized_test.apply(
        lambda x: [stemmer.stem(j) for j in x])  # stemming
    try:
        for i in range(len(tokenized_test)):
            tokenized_test[i] = ' '.join(tokenized_test[i])
        dataset['tweet'] = tokenized_test
    except Exception as e:
        print(e.__str__())

    return dataset
