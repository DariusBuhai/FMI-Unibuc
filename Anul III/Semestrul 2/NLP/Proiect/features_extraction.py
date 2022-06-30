import numpy as np
from collections import Counter
import spacy
import string
import torch
import operator

nlp = spacy.load("en_core_web_md")


def removePunctuationAndStopwords(data):
    all_words = []
    for word in data:
        if word not in nlp.Defaults.stop_words and word != ' ' and word not in string.punctuation:
            all_words.append(word)
    return all_words


def wordFrequency(data, min_occurences):
    all_words = [words.lower() for sentences in data for words in sentences]
    sorted_vocab = sorted(dict(Counter(all_words)).items(), key=operator.itemgetter(1))
    return [k for k, v in sorted_vocab if v > min_occurences]


def createVocab(reviews):
    vocab = wordFrequency(reviews, min_occurences=18)
    vocab = removePunctuationAndStopwords(vocab)
    return vocab


def pad(samples, max_length):
    return torch.tensor([
        sample[:max_length] + [1] * max(0, max_length - len(sample))
        for sample in samples
    ])


def createVectorize(vocab, reviews, total_features):
    word_indices = dict((c, i + 2) for i, c in enumerate(vocab))
    indices_word = dict((i + 2, c) for i, c in enumerate(vocab))
    indices_word[0] = 'UNK'
    word_indices['UNK'] = 0

    reviews_vectorized = vectorizeSentences(reviews, word_indices)
    reviews_vectorized = pad(reviews_vectorized, max_length=total_features)
    return reviews_vectorized


def vectorizeSentences(data, char_indices, one_hot=False):
    vectorized = []
    for sentences in data:
        sentences_of_indices = [char_indices[w] if w in char_indices.keys() else char_indices['UNK'] for w in sentences]
        if one_hot:
            sentences_of_indices = np.eye(len(char_indices))[sentences_of_indices]

        vectorized.append(sentences_of_indices)

    return vectorized


def extractDatasetFeatures(dataset, total_features=400):
    v = createVocab(dataset['tweet'])
    return createVectorize(v, dataset['tweet'], total_features)
