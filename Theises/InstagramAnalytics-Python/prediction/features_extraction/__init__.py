import pathlib
from datetime import datetime

import numpy as np
from collections import Counter

import pandas as pd
import spacy
import string
import torch
import operator

from sklearn.ensemble import RandomForestRegressor
from torch import Tensor


def getCurrentPath():
    return f"{pathlib.Path(__file__).parent.resolve()}/"


class FeaturesExtraction:
    PREV_POSTS_FILE = "../data/posts_preprocessed.csv"
    CURRENT_POSTS_FILE = "../data/posts_features.csv"
    VOCAB_FILE = "../data/vocab.csv"

    def __init__(self, posts=None):
        self.prediction_mode = False
        if posts is None:
            self.posts: pd.DataFrame = pd.read_csv(self.PREV_POSTS_FILE)
        else:
            self.prediction_mode = True
            self.posts = pd.DataFrame(posts)
        print("Loaded posts")
        self.vocab: list[str] = []

    @staticmethod
    def wordFrequency(data: pd.Series, min_occurrences):
        all_words = [word.lower() for sentence in data for word in sentence.split(' ')]
        sorted_vocab = sorted(dict(Counter(all_words)).items(), key=operator.itemgetter(1), reverse=True)
        return [k for k, v in sorted_vocab if v > min_occurrences]

    @staticmethod
    def pad(samples, max_length):
        return torch.tensor([
            sample[:max_length] + [0] * max(0, max_length - len(sample))
            for sample in samples
        ])

    def getVocabByIdx(self, idx):
        if len(self.vocab) > idx:
            return self.vocab[idx]
        return f"w{idx}"

    def removePunctuationAndStopwords(self):
        words = []
        for word in self.vocab:
            if word not in nlp.Defaults.stop_words and word != ' ' and word not in string.punctuation:
                words.append(word)
        self.vocab = words

    def createVocab(self):
        if self.prediction_mode:
            self.vocab = [x[1] for x in pd.read_csv(getCurrentPath() + self.VOCAB_FILE).to_numpy().tolist()]
            return
        self.vocab = self.wordFrequency(self.posts['description'], min_occurrences=18)
        self.removePunctuationAndStopwords()
        vocab = pd.DataFrame(self.vocab)
        vocab.to_csv(self.VOCAB_FILE)

    def createVectorize(self, total_features):
        vectorized = []
        for sentences in self.posts['description']:
            current_vector = []
            sentences_sep = sentences.split(" ")
            for i in range(total_features):
                word = self.vocab[i]
                if word in sentences_sep:
                    current_vector.append(1)
                else:
                    current_vector.append(0)
            vectorized.append(current_vector)
        return torch.FloatTensor(vectorized)

    def extractDatasetDescriptionFeatures(self, total_features=400) -> Tensor:
        self.createVocab()
        if not self.prediction_mode:
            print("Created vocabulary")
        return self.createVectorize(total_features)

    def dealWithEmptyDescriptions(self):
        new_posts = []
        for idx, post in self.posts.iterrows():
            if type(post['description']) is not str:
                post['description'] = ""
            new_posts.append(post)
        self.posts = pd.DataFrame(new_posts)

    def extractAllFeatures(self, posts_description_features) -> pd.DataFrame:
        # Day of week
        available_dates = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        time_intervals = [(8, 12), (12, 17), (17, 22), (22, 2), (2, 8)]

        new_posts = []

        mean_likes = dict()
        if not self.prediction_mode:
            for idx, post in self.posts.iterrows():
                if type(post['likes']) is not float and type(post['likes']) is not int:
                    continue
                if post['username'] in mean_likes:
                    old_mean, old_count = mean_likes[post['username']]
                    mean_likes[post['username']] = (
                    (old_mean * old_count + post['likes']) / (old_count + 1), old_count + 1)
                else:
                    mean_likes[post['username']] = (post['likes'], 1)

        for idx, post in self.posts.iterrows():
            try:
                new_post = dict()

                # Keep old features
                for feature in ["smiles", "faces", "followers", "engagement", "likes", "comments"]:
                    if feature not in post:
                        continue
                    if post[feature] is None:
                        post[feature] = 0.0
                    new_post[feature] = post[feature]
                if not self.prediction_mode:
                    new_post['likes/followers'] = post['likes'] / post['followers']
                    new_post['likes/mean'] = post['likes'] / mean_likes[post['username']][0]
                    new_post['mean'] = mean_likes[post['username']][0]

                # Day posted
                try:
                    date_posted = datetime.fromtimestamp(post['taken_at'])
                except:
                    date_posted = datetime.today()
                for date_day in available_dates:
                    new_post[date_day] = False
                new_post[date_posted.strftime('%A')] = True

                # Time interval
                for time_interval in time_intervals:
                    new_post[str(time_interval)] = False
                    hour_start = int(date_posted.strftime('%H'))
                    if time_interval[0] < hour_start <= time_interval[1]:
                        new_post[str(time_interval)] = True

                # Description features
                idx2 = 0
                for description_feature in posts_description_features[idx]:
                    new_post[f"word: {self.getVocabByIdx(idx2)}"] = int(description_feature)
                    idx2 += 1

                new_posts.append(new_post)

                if not self.prediction_mode:
                    print(f"Loaded features for row: {idx}")
            except Exception as e:
                print(e)
        if not self.prediction_mode:
            print("Converting to DataFrame (this may take a while)")
        return pd.DataFrame(new_posts)

    def extractPostsFeatures(self):
        self.dealWithEmptyDescriptions()
        if not self.prediction_mode:
            print("Removed empty descriptions")
        posts_description_features = self.extractDatasetDescriptionFeatures(total_features=200)
        if not self.prediction_mode:
            print("Extracted descriptions features")
            print("Loading post features: ")
        posts_features = self.extractAllFeatures(posts_description_features)
        if self.prediction_mode:
            return posts_features
        print("\nDone! Saving to csv")
        try:
            posts_features.to_csv(FeaturesExtraction.CURRENT_POSTS_FILE)
        except Exception as e:
            print(e)
            return
        print("Saved to csv")


if __name__ == "__main__":
    nlp = spacy.load("en_core_web_md")
    features_extraction = FeaturesExtraction()
    features_extraction.extractPostsFeatures()
