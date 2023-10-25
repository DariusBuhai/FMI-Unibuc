import pytest

from app.device.device import DeviceObject
from app.models import Device
from app.user.user import UserObject


@pytest.fixture
def device():
    device_alias = 'test'
    device = DeviceObject.create(UserObject.getMockUser(), {
        'alias': device_alias
    })
    assert (device.alias == device_alias)
    yield device


def test_create(device):
    assert (bool(DeviceObject.find(device.id)))


def test_update(device):
    device = DeviceObject(UserObject.getMockUser(), device.id)
    new_alias = 'updated alias'
    new_description = 'this is an updated device'
    device.update({
        'id': device.device_id,
        'alias': new_alias,
        'description': new_description,
    })
    updated_device: Device = DeviceObject.find(device.device_id)

    assert (updated_device.alias == new_alias)
    assert (updated_device.description == new_description)


def test_delete(device):
    device = DeviceObject(UserObject.getMockUser(), device.id)
    device.delete()
    assert (DeviceObject.find(device.device_id) is None)


def test_settings_handling(device):
    device = DeviceObject(UserObject.getMockUser(), device.id)

    schedule = [[8, 11], [19, 20]]
    device.addRuntimeSchedule(schedule)
    assert ('schedule' in device.device.settings
            and device.device.settings['schedule'] == schedule)

    device.setAlwaysOn(False)
    assert ('always_on' in device.device.settings
            and not device.device.settings['always_on'])

    channel_name = 'device@channel'
    device.setChannel(channel_name)
    assert ('channel' in device.device.settings
            and device.device.settings['channel'] == channel_name)

    settings = {
        'schedule': schedule,
        'always_on': False,
        'channel': channel_name,
    }

    assert (device.device.settings == settings)

