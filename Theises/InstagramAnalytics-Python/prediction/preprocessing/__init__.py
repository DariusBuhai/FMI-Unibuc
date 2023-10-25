import pandas as pd
from nltk.stem.porter import *
import re
import numpy as np


class Preprocessing:
    PREV_POSTS_FILE = "../data/posts_image_features.csv"
    CURRENT_POSTS_FILE = "../data/posts_preprocessed.csv"

    @staticmethod
    def removePattern(input_txt, pattern):
        r = re.findall(pattern, input_txt)
        for j in r:
            input_txt = re.sub(re.escape(j), '', input_txt)
        return input_txt

    @staticmethod
    def preprocessDataset(dataset: pd.DataFrame):
        # remove @user
        dataset['description'] = np.vectorize(Preprocessing.removePattern)(dataset['description'], "@[\w]*")

        # remove URL
        dataset['description'] = np.vectorize(Preprocessing.removePattern)(
            dataset['description'], "https?://[\S]+")
        dataset['description'] = np.vectorize(Preprocessing.removePattern)(
            dataset['description'], "http?://[\S]+")

        # remove Punctuations, Numbers, and Special Characters
        dataset['description'] = dataset['description'].str.replace("[^a-zA-Z#]", " ")

        # remove Short Words
        dataset['description'] = dataset['description'].apply(
            lambda x: ' '.join([w for w in x.split() if len(w) > 3]))

        # Convert to lower case
        dataset['description'] = dataset['description'].apply(
            lambda x: ' '.join([x.lower()]))

        # Convert more than 2 letter repetitions to 2 letter
        dataset['description'] = dataset['description'].apply(lambda x: ' '.join([re.sub(r'(.)\1+', r'\1\1', x)]))

        # Replaces #hashtag with hashtag
        dataset['description'] = dataset['description'].apply(lambda x: ' '.join([re.sub(r'#(\S+)', r' \1 ', x)]))

        # Replace multiple spaces with a single space
        dataset['description'] = dataset['description'].apply(
            lambda x: ' '.join([re.sub(r'\s+', ' ', x)]))

        # test text Normalization
        tokenized_test = dataset['description'].apply(lambda x: x.split())  # tokenizing

        # normalize the tokenized descriptions.
        stemmer = PorterStemmer()
        tokenized_test = tokenized_test.apply(
            lambda x: [stemmer.stem(j) for j in x])  # stemming
        try:
            for i in range(len(tokenized_test)):
                tokenized_test[i] = ' '.join(tokenized_test[i])
            dataset['description'] = tokenized_test
        except Exception as e:
            print(e.__str__())

        return dataset

    @staticmethod
    def dealWithEmptyDescriptions(posts: pd.DataFrame):
        new_posts = []
        for idx, post in posts.iterrows():
            if type(post['description']) is not str:
                post['description'] = ""
            new_posts.append(post)
        return pd.DataFrame(new_posts)

    @staticmethod
    def preprocessPosts(posts=None):
        prediction_mode = True
        if posts is None:
            prediction_mode = False
            posts = pd.read_csv(Preprocessing.PREV_POSTS_FILE)
        posts = Preprocessing.dealWithEmptyDescriptions(posts)
        print("Loaded posts")
        posts = Preprocessing.preprocessDataset(posts)
        if prediction_mode:
            return posts
        print("Preprocessed posts")
        posts.to_csv(Preprocessing.CURRENT_POSTS_FILE)
        print("Saved posts")


if __name__ == "__main__":
    Preprocessing.preprocessPosts()
