import datetime
from xmlrpc.client import _datetime_type

EXTENSION_NAME = '.pth'
BASE_PATH = './app/util/ML/'
TRAIN_FOLDER = "train_data/"
DEVICE_BASE_NAME = "device_"

def getDatetime(datestamp:str) -> datetime.datetime:
    date = datestamp.split(" ")[0]
    time = datestamp.split(" ")[1]

    year, month, day = [int(aux) for aux in date.split("-")]
    hour, minute, second = [int(float(aux)) for aux in time.split(":")]

    if minute != 30 and minute != 0:
        minute = 30

    new_datestamp = datetime.datetime(year, month, day, hour, minute, second)

    return new_datestamp
