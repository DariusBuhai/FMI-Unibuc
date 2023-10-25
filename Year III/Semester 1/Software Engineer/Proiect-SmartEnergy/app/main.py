from flask import Flask

# Instantiate Flask app
from app.device.route import app_device
from app.mqtt.mqtt_hub import initiateMqtt, MqttHub
from app.user.route import app_user
from app.util.database import Database


# Initiate server
def initiateFlask(testing=False):
    # Initiate app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(SECRET_KEY='dev')
    app.config['SQLALCHEMY_DATABASE_URI'] = f"sqlite:///{'app-test' if testing else 'app'}.sqlite"
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

    # Register blueprints
    app.register_blueprint(app_device)
    app.register_blueprint(app_user)

    # Initiate database
    Database.initiateDatabase(app)

    # Initiate mqtt
    initiateMqtt(app)

    # Initiate mqtt scheduler
    MqttHub.handle.initialize_scheduler()

    # Start watching mqtt endpoints
    # MqttHub.handle.watch_clients()

    return app
