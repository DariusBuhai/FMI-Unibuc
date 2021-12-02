from mpl_toolkits import mplot3d 
import matplotlib.pyplot as plt 

from sklearn.neural_network import MLPClassifier # importul clasei 
from sklearn import preprocessing

import numpy as np

# ------ exercitiul 1
def plot3d_data(X, y):
    ax = plt.axes(projection='3d')
    ax.scatter3D(X[y == -1, 0], X[y == -1, 1], X[y == -1, 2],'b');
    ax.scatter3D(X[y == 1, 0], X[y == 1, 1], X[y == 1, 2],'r'); 
    plt.show()
    
def plot3d_data_and_decision_function(X, y, W, b): 
    ax = plt.axes(projection='3d')
    # create x,y
    xx, yy = np.meshgrid(range(10), range(10))
    # calculate corresponding z
    # [x, y, z] * [coef1, coef2, coef3] + b = 0
    zz = (-W[0] * xx - W[1] * yy - b) / W[2]
    ax.plot_surface(xx, yy, zz, alpha=0.5) 
    ax.scatter3D(X[y == -1, 0], X[y == -1, 1], X[y == -1, 2],'b');
    ax.scatter3D(X[y == 1, 0], X[y == 1, 1], X[y == 1, 2],'r'); 
    plt.show()
    
# incarcarea datelor de antrenare
X = np.loadtxt('data/3d-points/x_train.txt')
y = np.loadtxt('data/3d-points/y_train.txt', 'float') 
y = y.astype(int)

plot3d_data(X, y)

# incarcarea datelor de testare
X_test = np.loadtxt('./data/3d-points/x_test.txt')
y_test = np.loadtxt('./data/3d-points/y_test.txt', 'float') 
y_test = y_test.astype(int)

from sklearn.linear_model import Perceptron
perceptron_model = Perceptron(penalty=None, alpha=0.0001, fit_intercept=True,tol=1e-5, 
                              shuffle=True, eta0=0.1, early_stopping=False, 
                              validation_fraction=0.1, n_iter_no_change=5)
perceptron_model.fit(X, y)

acc = perceptron_model.score(X, y)
acc_t = perceptron_model.score(X_test, y_test)

print(acc, acc_t)

print(f"Ponderi: {perceptron_model.coef_[0]}")
print(f"Bias: {perceptron_model.intercept_}")
print(f"Epoci parcurse: {perceptron_model.n_iter_}")

plot3d_data_and_decision_function(X, y, perceptron_model.coef_[0], perceptron_model.intercept_)

# ------ exercitiul 2
from sklearn.neural_network import MLPClassifier

def train_and_test(mlp_model, X, y, X_test, y_test):
    mlp_model.fit(X, y)
    acc = mlp_model.score(X_test, y_test)
    print(acc)

# a
mlp_classifier_model = MLPClassifier(activation='tanh', hidden_layer_sizes=(1), learning_rate_init=0.01, momentum=0, max_iter=200)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# b
mlp_classifier_model = MLPClassifier(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=0.01, momentum=0, max_iter=200)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# c
mlp_classifier_model = MLPClassifier(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=0.00001, momentum=0, max_iter=200)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# d
mlp_classifier_model = MLPClassifier(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=10, momentum=0, max_iter=20)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# e
mlp_classifier_model = MLPClassifier(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=0.01, momentum=0, max_iter=2000)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# f
mlp_classifier_model = MLPClassifier(activation='tanh', hidden_layer_sizes=(10, 10), learning_rate_init=0.01, momentum=0, max_iter=2000)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# g
mlp_classifier_model = MLPClassifier(activation='relu', hidden_layer_sizes=(10, 10), learning_rate_init=0.01, momentum=0, max_iter=2000)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# h
mlp_classifier_model = MLPClassifier(activation='relu', hidden_layer_sizes=(100, 100), learning_rate_init=0.01, momentum=0, max_iter=2000)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# i
mlp_classifier_model = MLPClassifier(activation='relu', hidden_layer_sizes=(100, 100), learning_rate_init=0.01, momentum=0.9, max_iter=2000)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)
# j
mlp_classifier_model = MLPClassifier(activation='relu', hidden_layer_sizes=(100, 100), learning_rate_init=0.01, momentum=0.9, max_iter=2000, alpha=0.005)
train_and_test(mlp_classifier_model, X, y, X_test, y_test)



