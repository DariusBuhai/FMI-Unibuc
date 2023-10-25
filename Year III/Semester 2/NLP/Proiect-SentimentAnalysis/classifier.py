import numpy
import numpy as np
import pandas as pd
from torch.utils.data import DataLoader

from preprocessing import preprocessDataset
from features_extraction import extractDatasetFeatures
import pickle
from os.path import exists

import torch


class Model(torch.nn.Module):
    def __init__(self, size, out, p=.4):
        super().__init__()
        self.embedding = torch.nn.Embedding(size, size, padding_idx=1)
        conv1 = torch.nn.Sequential(
            torch.nn.Conv1d(in_channels=size, out_channels=128, kernel_size=3, padding=1),
            torch.nn.BatchNorm1d(num_features=128),
            torch.nn.ReLU(),
            torch.nn.MaxPool1d(kernel_size=2),
        )
        conv2 = torch.nn.Sequential(
            torch.nn.Conv1d(in_channels=128, out_channels=128, kernel_size=5, padding=2),
            torch.nn.BatchNorm1d(num_features=128),
            torch.nn.ReLU(),
            torch.nn.MaxPool1d(kernel_size=2),
        )
        global_average = torch.nn.AvgPool1d(kernel_size=100, stride=128)
        self.convolutions = torch.nn.Sequential(
            torch.nn.Dropout(p=p),
            conv1,
            conv2,
            global_average
        )
        flatten = torch.nn.Flatten()
        linear = torch.nn.Linear(in_features=128, out_features=out)
        self.classifier = torch.nn.Sequential(flatten, linear)

    def forward(self, input):
        embeddings = self.embedding(input)
        embeddings = embeddings.permute(0, 2, 1)
        output = self.convolutions(embeddings)
        output = self.classifier(output)
        return output


class Dataset(torch.utils.data.Dataset):
    def __init__(self, dataframe: pd.DataFrame, features):
        self.samples = features.astype(float)
        self.labels = dataframe['label'].to_numpy().astype(float)

    def __getitem__(self, k):
        """Returneaza al k-lea exemplu din dataset"""
        return self.samples[k], self.labels[k]

    def __len__(self):
        """Returneaza dimensiunea datasetului"""
        return len(self.samples)


class Classifier:
    def __init__(self, features=400, out=2):
        # Initiate variables
        self.__train_df, self.__test_df, self.__validation_df = pd.DataFrame(), pd.DataFrame(), pd.DataFrame()
        self.__train_ft, self.__test_ft, self.__validation_ft = pd.DataFrame(), pd.DataFrame(), pd.DataFrame()

        # Init dataset
        self.__initiateDataframe()
        self.__performPreprocessing()
        self.__extractFeatures(features)

        # Initiate dataset class
        self.test_dl = DataLoader(Dataset(self.__test_df, self.__test_ft.numpy()), batch_size=64, shuffle=True)
        self.validation_dl = DataLoader(Dataset(self.__validation_df, self.__validation_ft.numpy()), batch_size=64,
                                        shuffle=True)
        self.train_dl = DataLoader(Dataset(self.__train_df, self.__train_ft.numpy()), batch_size=64, shuffle=True)

        # Initiate model`
        self.model = Model(features, out)
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=0.001)
        self.loss_fn = torch.nn.CrossEntropyLoss()

    def __initiateDataframe(self):
        # Generate train and test data\\
        dataset = pd.read_csv("dataset/racism-dataset.csv")
        msk = pd.np.random.rand(len(dataset)) < 0.8
        self.__train_df = dataset[msk]
        dataset2 = dataset[~msk]
        msk2 = pd.np.random.rand(len(dataset2)) < 0.5
        self.__validation_df = dataset2[~msk2]
        self.__test_df = dataset2[msk2]

    def __performPreprocessing(self):
        if exists("./pickles/preprocessed_dataset.pck"):
            pck = open("./pickles/preprocessed_dataset.pck", "rb")
            result = pickle.load(pck)
            self.__test_df = result['test_df']
            self.__train_df = result['train_df']
            self.__validation_df = result['validation_df']
            return
        # Perform preprocessing
        self.__test_df = preprocessDataset(self.__test_df)
        print("Preprocessed test dataframe")
        self.__validation_df = preprocessDataset(self.__validation_df)
        print("Preprocessed validation dataframe")
        self.__train_df = preprocessDataset(self.__train_df)
        print("Preprocessed train dataframe")
        # Save preprocessed dataset
        pck = open("./pickles/preprocessed_dataset.pck", "wb")
        pickle.dump({
            'test_df': self.__test_df,
            'train_df': self.__train_df,
            'validation_df': self.__validation_df,
        }, pck)

    def __extractFeatures(self, features):
        if exists("./pickles/preprocessed_features.pck"):
            pck = open("./pickles/preprocessed_features.pck", "rb")
            result = pickle.load(pck)
            self.__test_ft = result['test_ft']
            self.__validation_ft = result['validation_ft']
            self.__train_ft = result['train_ft']
            return
        # Extract features
        self.__test_ft = extractDatasetFeatures(self.__test_df, features)
        print("Extracted test features")
        self.__validation_ft = extractDatasetFeatures(self.__validation_df, features)
        print("Extracted validation features")
        self.__train_ft = extractDatasetFeatures(self.__train_df, features)
        print("Extracted train features")
        # Save preprocessed features
        pck = open("./pickles/preprocessed_features.pck", "wb")
        pickle.dump({
            'test_ft': self.__test_ft,
            'validation_ft': self.__validation_ft,
            'train_ft': self.__train_ft
        }, pck)

    def loadBestModel(self):
        try:
            self.model.load_state_dict(torch.load("./models/best_model.pt"))
            return True
        except:
            return False

    def __saveBestModel(self):
        torch.save(self.model.state_dict(), "models/best_model.pt")

    def trainModel(self, epochs, best_val_acc=0):
        self.loadBestModel()
        for epoch_n in range(epochs):
            print(f"Epoch #{epoch_n + 1}")
            self.model.train()
            for batch in self.train_dl:
                self.model.zero_grad()

                inputs, targets = batch
                inputs = inputs.float().long()
                targets = targets.long()

                output = self.model(inputs)
                loss = self.loss_fn(output, targets)

                loss.backward()
                self.optimizer.step()

            # validate
            val_acc = self.evaluateModel(self.validation_dl)

            if val_acc > best_val_acc:
                self.__saveBestModel()
                print(f"Saving best model with accuracy: {val_acc}")
                best_val_acc = val_acc

        print("Best validation accuracy", best_val_acc)

    def evaluateModel(self, dataload):
        self.model.eval()
        all_predictions = torch.tensor([])
        all_targets = torch.tensor([])
        for batch in dataload:
            inputs, targets = batch
            inputs = inputs.float().long()
            targets = targets.long()

            with torch.no_grad():
                output = self.model(inputs)

            predictions = output.argmax(1)
            all_targets = torch.cat([all_targets, targets.detach().cpu()])
            all_predictions = torch.cat([all_predictions, predictions.detach().cpu()])
        all_acc = (all_predictions == all_targets).float().mean().numpy()

        # Calculating accuracy for each category
        all_targets_cat0, all_predictions_cat_0 = [], []
        all_targets_cat1, all_predictions_cat_1 = [], []
        idx = 0
        for target in all_targets:
            if target == 1:
                all_targets_cat1.append(1)
                all_predictions_cat_1.append(all_predictions[idx])
            else:
                all_targets_cat0.append(0)
                all_predictions_cat_0.append(all_predictions[idx])
            idx += 1
        cat0_acc = (torch.tensor(all_predictions_cat_0) == torch.tensor(all_targets_cat0)).float().mean().numpy()
        cat1_acc = (torch.tensor(all_predictions_cat_1) == torch.tensor(all_targets_cat1)).float().mean().numpy()

        # We are interested in the average
        avg_acc = (cat0_acc + cat1_acc) / 2

        print(f"Accuracy: {all_acc}")
        print(f"T_accuracy: {cat1_acc}, F_accuracy: {cat0_acc}")
        print(f"Avg accuracy: {avg_acc}\n")
        return avg_acc


if __name__ == "__main__":
    classifier = Classifier()
    for _ in range(40):
        val_acc = 0
        if classifier.loadBestModel():
            val_acc = classifier.evaluateModel(classifier.validation_dl)
        classifier.trainModel(100, val_acc)
        print("Test accuracy: ")
        classifier.evaluateModel(classifier.test_dl)
    if classifier.loadBestModel():
        print("Test accuracy: ")
        classifier.evaluateModel(classifier.test_dl)
