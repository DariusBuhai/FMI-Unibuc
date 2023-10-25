import numpy as np
import math
import scipy.stats as stats


def n(a):
    return np.array(a)


# Functie de activare
def activate(x, activation="sign", alpha: float = 0):
    activation = activation.lower()
    if activation == "identity":
        return x
    if activation == "sign":
        return 1 if x >= 0 else -1
    if activation == "sigmoid":  # (0, 1)
        return 1 / (1 + math.e ** (-x))
    if activation == "relu":  # [0, inf)
        return 0 if x <= 0 else x
    if activation == "leaky relu":  # (-inf, inf)
        return 0.01 * x if x < 0 else x
    if activation == "prelu":  # (-inf, inf)
        return alpha * x if x < 0 else x
    if activation == "tanh":  # (-1, 1)
        return (math.e ** x - math.e ** (-x)) / (math.e ** x + math.e ** (-x))
    if activation == "elu":  # (-alpha, inf)
        return alpha * (math.e ** x - 1) if x <= 0 else x


# Perceptron
def perceptron(W: list, X: list, b: float, activation="sign"):
    W = np.array(W)
    y = list()
    for x in X:
        x = np.array(x)
        yi = sum((W * x)) + b
        yi = activate(yi, activation)
        y.append(yi)
    return y


# Masura Fb
def measure_f(precision, recall, B=1):
    return (1 + B ** 2) * ((precision * recall) / ((B ** 2 * precision) + recall))


def confusion_matrix(predicted_labels, ground_truth_labels, indexed=1):
    ground_truth_labels = np.array(ground_truth_labels)
    predicted_labels = np.array(predicted_labels)
    num_labels = max(ground_truth_labels) + 1
    conf_mat = np.zeros((num_labels - indexed, num_labels - indexed))

    for i in range(len(predicted_labels)):
        conf_mat[ground_truth_labels[i] - indexed, predicted_labels[i] - indexed] += 1
    return conf_mat.astype("int")


def MSE(y_pred: list, y_true: list):
    n = len(y_true)
    sums = 0
    for i in range(n):
        sums += (y_true[i] - y_pred[i]) ** 2
    return (1 / n) * sums


def kendall_tau(x, y):
    tau, _ = stats.kendalltau(x, y)
    return tau


def dual_form(X_train, X_test):
    return X_train.dot(X_test.T)


def precision(TP, FP):
    return TP / (TP + FP)


def recall(TP, FN):
    return TP / (TP + FN)


def specificity(TN, FP):
    return TN / (TN + FP)


def accuracy(TP, TN, FP, FN):
    return (TP + TN) / (TP + TN + FP + FN)


def B_cond_A(A_cond_B, A, B):
    return A_cond_B * B / A


# Gets the standardization of data
def compute_standardization2(train, test):
    train = n(train).T
    test = n(test).T

    for i in range(train.shape[0]):
        me = train[i].mean()
        st = train[i].std()
        train[i] = (train[i] - me) / st
        test[i] = (test[i] - me) / st

        print(f"Feature #{i}: mean is {me:.4f}, std is {st:.4f}")

    train = train.T
    test = test.T

    return train, test


def compute_standardization(train):
    a, _ = compute_standardization2(train, train)
    return a


def main():
    W = []
    X = []
    b = 1
    print(perceptron(W, X, b))


if __name__ == '__main__':
    main()
