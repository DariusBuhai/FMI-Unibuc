import pathlib

import numpy as np
import pandas as pd
import sklearn.metrics as sm
from matplotlib import pyplot
from torch.utils.data import DataLoader
import torch


def getCurrentPath():
    return f"{pathlib.Path(__file__).parent.resolve()}/"


class Model(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.layers = torch.nn.Sequential(
            torch.nn.Linear(214, 256),
            torch.nn.ReLU(),
            torch.nn.Linear(256, 128),
            torch.nn.ReLU(),
            torch.nn.Linear(128, 32),
            torch.nn.ReLU(),
            torch.nn.Dropout(0.4),
            torch.nn.Linear(32, 1)
        )

    def forward(self, x):
        return self.layers(x)


class Dataset(torch.utils.data.Dataset):
    def __init__(self, features: pd.DataFrame):
        self.samples = features.loc[:, ~features.columns.isin(
            ['Unnamed: 0', 'likes', 'likes/followers', 'followers', 'comments', 'engagement', 'likes/mean', 'mean'])].to_numpy().astype(float)
        self.labels = features['likes/followers'].to_numpy().astype(float)

    def __getitem__(self, k):
        """Returneaza al k-lea exemplu din dataset"""
        return self.samples[k], self.labels[k]

    def __len__(self):
        """Returneaza dimensiunea datasetului"""
        return len(self.samples)


class Regressor:
    MODELS_PATH = "../models"
    CURRENT_FEATURES_FILE = "../data/posts_features.csv"

    def __init__(self):
        # Initiate variables
        self.train_ft: pd.DataFrame
        self.test_ft: pd.DataFrame
        self.validation_ft: pd.DataFrame

        # Init dataset
        self.__initiateDataframe()

        # Initiate dataset class
        self.test_dl: DataLoader = DataLoader(Dataset(self.test_ft), batch_size=64, shuffle=False)
        self.validation_dl: DataLoader = DataLoader(Dataset(self.validation_ft), batch_size=64, shuffle=False)
        self.train_dl: DataLoader = DataLoader(Dataset(self.train_ft), batch_size=64, shuffle=True)

        # Initiate model`
        self.model = Model()
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=1e-4)
        self.loss_fn = torch.nn.L1Loss()

    def __initiateDataframe(self):
        # Generate train and test data
        dataset = pd.read_csv(self.CURRENT_FEATURES_FILE)
        dataset = dataset.fillna(0)
        msk = pd.np.random.rand(len(dataset)) < 0.8
        self.train_ft = dataset[msk]
        dataset2 = dataset[~msk]
        msk2 = pd.np.random.rand(len(dataset2)) < 0.5
        self.validation_ft = dataset2[~msk2]
        self.test_ft = dataset2[msk2]

    def loadModel(self, name="best_model"):
        try:
            self.model.load_state_dict(torch.load(f"{getCurrentPath()}{self.MODELS_PATH}/{name}.pt"))
            print("Loaded best model!")
            return True
        except:
            return False

    def __saveBestModel(self):
        torch.save(self.model.state_dict(), f"{getCurrentPath()}{self.MODELS_PATH}/best_model.pt")
        print("Model saved")

    def trainModel(self, epochs: int):
        # Run the training loop
        for epoch in range(0, epochs):
            self.model.train()
            all_targets, all_outputs = np.array([]), np.array([])
            print(f'Starting epoch {epoch + 1}')
            # Iterate over the DataLoader for training data
            for i, data in enumerate(self.train_dl, 0):
                # Get and prepare inputs
                inputs, targets = data
                inputs, targets = inputs.float(), targets.float()
                targets = targets.reshape((targets.shape[0], 1))
                # Zero the gradients
                self.optimizer.zero_grad()
                # Perform forward pass
                outputs = self.model(inputs)
                all_targets = np.concatenate((all_targets, targets.reshape(targets.shape[0]).numpy()))
                all_outputs = np.concatenate((all_outputs, outputs.reshape(outputs.shape[0]).detach().numpy()))

                # Compute loss
                loss = self.loss_fn(outputs, targets)
                loss.backward()
                # Perform optimization
                self.optimizer.step()
                self.optimizer.zero_grad()
            print("MSE: ", sm.mean_squared_error(all_outputs, all_targets))
            print("Mean absolute error: ", sm.mean_absolute_error(all_outputs, all_targets))
            print("R2 score: ", sm.r2_score(all_outputs, all_targets))
            print()
            self.evaluateModel(self.validation_dl, dataset_name="Validation")
            self.__saveBestModel()

    def evaluateModel(self, dataloader: DataLoader, dataset_name: str = "Test", detailed=False):
        self.model.eval()
        all_targets, all_outputs = np.array([]), np.array([])
        # Iterate over the DataLoader for training data
        for i, data in enumerate(dataloader, 0):
            # Get and prepare inputs
            inputs, targets = data
            inputs, targets = inputs.float(), targets.float()
            targets = targets.reshape((targets.shape[0], 1))
            # Perform forward pass
            outputs = self.model(inputs)
            all_targets = np.concatenate((all_targets, targets.reshape(targets.shape[0]).numpy()))
            all_outputs = np.concatenate((all_outputs, outputs.reshape(outputs.shape[0]).detach().numpy()))
        print(f"{dataset_name} accuracy: ")
        print("MSE: ", sm.mean_squared_error(all_outputs, all_targets))
        print("Mean absolute error: ", sm.mean_absolute_error(all_outputs, all_targets))
        print("R2 score: ", sm.r2_score(all_outputs, all_targets))
        return all_outputs, all_targets


if __name__ == "__main__":
    regressor = Regressor()
    regressor.loadModel()
    regressor.trainModel(10000)
