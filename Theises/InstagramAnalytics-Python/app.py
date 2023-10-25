from flask import Flask

from api.analytics.route import app_analytics
from api.auth.route import app_auth
from api.general.route import app_general
from api.prediction_api.route import app_prediction_api
from api.user.route import app_user

app = Flask(__name__)
app.register_blueprint(app_general)
app.register_blueprint(app_auth)
app.register_blueprint(app_user)
app.register_blueprint(app_prediction_api)
app.register_blueprint(app_analytics)

if __name__ == '__main__':
    app.run(threaded=True, port=8000)
