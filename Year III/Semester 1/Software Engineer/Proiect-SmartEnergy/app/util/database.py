from random import choice, randint
from flask import Flask
from flask_migrate import Migrate

from app.device.meter import Meter
from app.device.device import DeviceObject
from app.models import User, Device, Data, Event
from app.models.db import db

class Database:
    @staticmethod
    def importRelevantData(app, testing=False):
        with app.app_context():
            # Migrate database
            migrate = Migrate(app, db)

            # Initiate database
            db.init_app(app)
            db.create_all()
            migrate.init_app(app)

            username = 'mock-user'
            user = db.session.query(User).filter_by(username=username).first()
            if user is None:
                user = User(username=username, email=username + '@smartenergy.cloud')
                user.set_password('password')
                db.session.add(user)
                db.session.commit()

            # Export meter data
            if not testing:
                for year in [2014, 2015, 2016]:
                    for meter_id in range(1, 4):
                        if meter_id == 3 and year == 2014:
                            continue
                        Meter.exportCsvToDatabase(user, year, meter_id)

    @staticmethod
    def populateDeviceSettings(app):

        with app.app_context():
            for did in db.session.query(Device).all():

                mock_user = db.session.query(User).filter_by(username="mock-user").first()
                device = DeviceObject(user=mock_user, device_id=did.id)

                if "Lights" in device.device.alias:
                    device_channel = "/perdevice/lights"
                else:
                    device_channel = f"/perdevice/{did.alias[:-5]}"
                
                device.updateSettings(
                {
                    "handlers": 
                    {
                        "alarm": 
                        {
                            "seconds": randint(20, 80),
                            "repeats": choice([1, -1, 2]),
                            "device_uuid": did.uuid,
                            "content_generator": "ping_alive"
                        },
                        "schedule_tracker": 
                        {
                            "device_uuid": did.uuid
                        },
                        "power_schedule_tracker": 
                        {
                            "device_uuid": did.uuid
                        }
                    },
                    "channel": device_channel,
                    "always_on": False,
                    "schedule": [(randint(0, 15), randint(16, 22))],
                    "power_schedule": [(randint(0, 4), randint(5, 7), "D0", "D2"), 
                                        (randint(9, 11), randint(12, 14), "D0", "D3HOT"), 
                                        (randint(17, 21), randint(21, 23), "D0", "D1")]
                })

    @staticmethod
    def cleanDatabase():
        # If the database is not the test one, avoid using this
        if str(db.engine.url).find('app-test.sqlite') == -1:
            raise RuntimeError()

        db.session.query(Device).delete()
        db.session.query(Data).delete()
        db.session.query(Event).delete()
        db.session.query(User).delete()
        db.session.commit()

    @staticmethod
    def initiateDatabase(app):
        # Migrate database
        migrate = Migrate(app, db)

        # Initiate database
        db.init_app(app)
        with app.app_context():
            db.create_all()
        migrate.init_app(app, db)


if __name__ == "__main__":
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///../app.sqlite'
    Database.importRelevantData(app)
    Database.populateDeviceSettings(app)
