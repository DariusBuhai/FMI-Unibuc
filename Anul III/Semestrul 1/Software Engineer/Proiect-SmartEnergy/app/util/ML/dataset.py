import torch as T
import numpy as np

from app.util.ML.constants import *

DEVICE = T.device("cpu")
GPU_ENABLED = False


class DeviceMeterDataset(T.utils.data.Dataset):
    @staticmethod
    def createDatasets(device_id, mul_factor=1):
        allData = np.load(BASE_PATH + TRAIN_FOLDER + DEVICE_BASE_NAME + str(device_id) + ".npy")
        data_length = allData.shape[0]
        used_data = min(data_length // 2, 50000)
        increasing_factor = min(int(data_length * 2 / 10), 8000)

        np.random.shuffle(allData)

        ans = {
            "train": DeviceMeterDataset(allData[:used_data], mul_factor),
            "validation": DeviceMeterDataset(allData[used_data:used_data + increasing_factor], mul_factor),
            "test": DeviceMeterDataset(allData[used_data + increasing_factor:used_data + 2 * increasing_factor],
                                       mul_factor)
        }

        return ans

    # we need to generate mean error to have a comparasion basis for anomaly detections 
    @staticmethod
    def createEvalData(device_id, mul_factor=1):
        allData = np.load(BASE_PATH + TRAIN_FOLDER + DEVICE_BASE_NAME + str(device_id) + ".npy")

        index = np.random.choice(allData.shape[0], 1000, replace=False)
        max_index = allData.shape[0] - 12
        index = index[index < max_index]

        evalData = []
        for id in index:
            evalData.append(allData[id:id + 12, :].copy())

        for data in evalData:
            data[:, 3] *= mul_factor

        return evalData

    def __init__(self, data, mul_factor=1):
        self.allData = data
        self.allData[:, 3] *= mul_factor

        self.xy_data = T.tensor(self.allData, dtype=T.float32).to(DEVICE)

    def __len__(self):
        return len(self.xy_data)

    def __getitem__(self, idx):
        data = self.xy_data[idx, :3]
        value = self.xy_data[idx, 3].reshape((1))
        return data, value
