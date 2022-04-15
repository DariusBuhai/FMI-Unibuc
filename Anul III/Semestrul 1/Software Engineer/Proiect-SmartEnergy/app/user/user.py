from app.device.device import DeviceObject
from app.models.db import db
from app.models.user import User
from app.device.meter import Meter


class UserObject:
    def __init__(self, user: User) -> None:
        self.user = user

    @staticmethod
    def getMockUser() -> User:
        username = 'mock-user'
        return db.session.query(User).filter_by(username=username).first()

    # returns the model associated with the devices
    def getUserDevices(self):
        meter = Meter(self.user)
        return [x for x in meter.devices]

    # returns the most consuming device, and for each device the total consumption, daily consumption
    def getMonthlyStatistics(self, year, month):
        devices = self.getUserDevices()
        devices = [DeviceObject(self.user, device.id) for device in devices]

        max_consumption = 0
        max_id = 0

        statistics = dict()
        statistics['devices consumption'] = list()

        mean_daily_consumption = None
        for device in devices:
            total_consumption, mean_daily_consumption = device.getMonthlyConsumption(year, month)

            if total_consumption > max_consumption:
                max_consumption = total_consumption
                max_id = device.device_id

            statistics['devices consumption'].append({
                "device name: ": device.device.alias.split("[kW]")[0],
                "total consumption this month (kW): ": total_consumption,
                "average daily consumption (kW): ": mean_daily_consumption,
            })

            # print(device.device_id, device.device.alias, total_consumption, mean_daily_consumption)

        statistics['most consuming device'] = {
            "device name: ": [x.device.alias.split("[kW]")[0] for x in devices if x.device_id == max_id][0],
            "total consumption (kW): ": max_consumption,
            "aaverage daily consumption (kW): ": mean_daily_consumption
        }

        return statistics

    def getUnoptimizedDevices(self, year, month):
        devices = self.getUserDevices()
        devices = [DeviceObject(self.user, device.id) for device in devices]

        devicesToBeOptimized = []

        for device in devices:
            total_prediction, avg_prediction = device.getMonthlyPrediction(year, month)
            total_real, avg_real = device.getMonthlyConsumption(year, month)

            if total_real > 1.5 * total_prediction:
                devicesToBeOptimized.append({
                    "device name: ": device.device.alias.split("[kW]")[0],
                    "predicted consumption: ": total_prediction,
                    "real consumption: ": total_real,
                    "tip: ": "Reduce the consumption by keeping the old habits"
                })

            print(f"device {device.device_id} done")

        return devicesToBeOptimized
