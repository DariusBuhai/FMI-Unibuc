import datetime

import pytest

from app.device.device import DeviceObject
from app.device.meter import Meter
from app.models import Device
from app.models.db import db
from app.user.user import UserObject
from random import randint


@pytest.fixture
def device():
    Meter.exportCsvToDatabase(UserObject.getMockUser(), 'test', 1)
    yield db.session.query(Device).get(1)


def test_add_data_to_device(device):
    data_count = len(device.data)

    device_object = DeviceObject(UserObject.getMockUser(), device.id)
    device_object.addData('2015-01-30', randint(0, 42))

    new_data_count = len(device_object.device.data)
    assert (0 < data_count < new_data_count == data_count + 1)


def test_detect_anomaly(device):
    device_object = DeviceObject(UserObject.getMockUser(), device.id)
    last_entry = sorted(device_object.device.data, key=lambda x: x.time, reverse=True)[0]
    new_entry_time = last_entry.time + datetime.timedelta(minutes=5)
    device_object.addData(str(new_entry_time), 2 ** 16)

    assert (device_object.anomalyCheck(new_entry_time))


def test_do_not_detect_anomaly(device):
    device_object = DeviceObject(UserObject.getMockUser(), device.id)
    last_entry = sorted(device_object.device.data, key=lambda x: x.time, reverse=True)[0]
    new_entry_time = last_entry.time + datetime.timedelta(minutes=5)
    device_object.addData(str(new_entry_time), last_entry.value)

    assert (not device_object.anomalyCheck(new_entry_time))


def test_monthly_consumption(device):
    device_object = DeviceObject(UserObject.getMockUser(), device.id)
    real_consumption, real_avg_consumption = 300, 10
    predicted_consumption, predicted_avg_consumption = device_object.getMonthlyPrediction(year=2015, month=1)

    assert (real_consumption * 0.75 < predicted_consumption < real_consumption * 1.25)
    assert (real_avg_consumption * 0.75 < predicted_avg_consumption < real_avg_consumption * 1.25)
