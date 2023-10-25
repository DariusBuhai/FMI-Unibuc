import os
import time

from app.util.ML.anomaly_detector import AnomalyDetector
from app.util.ML.constants import *


def train(device_id):
    print(f"No model found for device with id {device_id}. Started generating the model")
    start_time = time.time()
    anomalyDetector = AnomalyDetector(device_id)

    anomalyDetector.train(200, 1e-3, 2)
    anomalyDetector.train(250, 1e-3, 2)
    anomalyDetector.train(300, 1e-3, 2)

    anomalyDetector.eval_mean_loss()

    end_time = time.time()
    print(f"Elapsed time for training the device was {end_time - start_time}")


def main():
    models_path = BASE_PATH + "/device_models/"
    models = os.listdir(models_path)

    devices_with_model = [model.split(".")[0].split("_")[-1] for model in models]

    data_path = BASE_PATH + "train_data"
    devices_data = os.listdir(data_path)
    devices_with_data = [data.split("_")[1].split(".")[0] for data in devices_data]

    for device_id in devices_with_data:
        if device_id not in devices_with_model:
            train(device_id)


def custom_train(device_id):
    train(device_id)


if __name__ == "__main__":
    custom_train(1)
    custom_train(2)
    custom_train(3)
    custom_train(6)
    custom_train(7)
    custom_train(8)
    custom_train(29)
    main()
    
