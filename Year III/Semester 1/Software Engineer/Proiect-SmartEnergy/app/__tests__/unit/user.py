import datetime
import pytest

from app.device.device import DeviceObject
from app.device.meter import Meter
from app.user.user import UserObject


@pytest.fixture
def user():
    user = UserObject.getMockUser()
    Meter.exportCsvToDatabase(UserObject.getMockUser(), 'test', 1)
    assert (bool(user))
    yield user


def test_get_user_devices(user):
    devices = user.devices

    assert (len(UserObject(user).getUserDevices()) == len(devices))


def test_get_unoptimized_devices(user):
    device_object = DeviceObject(user, user.devices[0].id)

    # Add a new entry that will make the device unoptimized
    last_entry = sorted(device_object.device.data, key=lambda x: x.time, reverse=True)[0]
    new_entry_time = last_entry.time + datetime.timedelta(minutes=5)
    device_object.addData(str(new_entry_time), 2 ** 16)

    unoptimized_devices = UserObject(user).getUnoptimizedDevices(year=2015, month=1)
    assert (len(unoptimized_devices) > 0)


def test_get_user_statistics(user):
    statistics = UserObject(user).getMonthlyStatistics(year=2015, month=1)

    assert (len(statistics['devices consumption']) == len(user.devices))
