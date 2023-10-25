from flask import Blueprint, request, jsonify

from api.analytics.analytics import Analytics
from util.errors import NetworkError
from util.general import checkValidPostRequest

app_analytics = Blueprint('analytics', __name__)


# API
@app_analytics.route('/api/get/instagram_user', methods=['GET'])
def getUser():
    token = request.args.get("token", None)
    username = request.args.get("username", None)
    valid, user_id = checkValidPostRequest([], {"token": token})
    if not valid:
        return valid

    analytics = Analytics()
    response = analytics.getAccountDetails(user_id, username)

    if type(response) is NetworkError:
        return response.getResponse()

    return jsonify(response)
