import numpy as np


def n(a):
    return np.array(a)


class KnnClassifier:
    def __init__(self, train_X, train_y):
        self.train_X = train_X
        self.train_y = train_y

    def classify_data(self, X, num_neighbors=3, metric='l2'):
        if metric == 'l1':
            distances = np.sum(np.abs(self.train_X - X), axis=1)
        elif metric == 'l2':
            distances = np.sqrt(np.sum(((self.train_X - X) ** 2), axis=1))
        else:
            raise Exception("Metric not implemented")
        sorted_indices = distances.argsort()
        nearest_indices = sorted_indices[:num_neighbors]
        nearest_labels = self.train_y[nearest_indices]

        return np.bincount(nearest_labels).argmax()

    def classify_datas(self, test_X, num_neighbors=3, metric='l2'):
        predicted_labels = [self.classify_data(data, num_neighbors, metric) for data in test_X]

        return np.array(predicted_labels)


def accuracy_score(ground_truth_labels, predicted_labels):
    return np.mean(ground_truth_labels == predicted_labels)


def main():
    X_train = n([[2, 2], [1, 2], [1, 1], [2, 1]])
    Y_train = n([0, 1, 1, 0])
    knn_classifier = KnnClassifier(X_train, Y_train)
    prediction = knn_classifier.classify_data(n([2, 2]))
    print(prediction)
    # print(accuracy_score(Y_train, prediction))


if __name__ == '__main__':
    main()
