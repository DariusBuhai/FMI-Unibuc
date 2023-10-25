import base64
import json

from flask import Blueprint, request, Response, jsonify, send_file

from api.user.user import User

from util.errors import NetworkError
from util.general import checkValidPostRequest

app_user = Blueprint('user', __name__)


# API
@app_user.route('/api/get/auth/user', methods=['GET'])
def getUser():
    token = request.args.get("token", None)
    valid, user_id = checkValidPostRequest([], {"token": token})
    if not valid:
        return valid

    user = User(user_id)
    resp = user.getUser()
    if resp is None:
        return Response(status=403)

    return jsonify(resp)


@app_user.route('/api/get/auth/image', methods=['GET'])
def getUserImage():
    token = request.args.get("token", None)
    valid, user_id = checkValidPostRequest([], {"token": token})
    if not valid:
        return valid

    profile = User(user_id)
    image_path = profile.getUserImage()

    if image_path is None:
        return send_file("templates/assets/images/null-image.png", mimetype="image")
    return send_file(image_path, mimetype="image")


@app_user.route('/api/post/auth/image', methods=['POST'])
def addUserImage():
    token = request.args.get("token", None)
    valid, user_id = checkValidPostRequest([], {"token": token})
    if not valid:
        return valid
    image = base64.b64decode(request.data)

    profile = User(user_id)
    resp = profile.addUserImage(image)
    if resp is None:
        return Response(status=403)

    return Response(status=200)


@app_user.route('/api/put/auth/update_password', methods=['PUT'])
def updatePassword():
    request_data = json.loads(request.data)
    valid, user_id = checkValidPostRequest(["old_password", "new_password"], request_data)
    if not valid:
        return valid

    profile = User(user_id)
    resp = profile.changePassword(request_data["old_password"], request_data["new_password"])

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)


@app_user.route('/api/put/user', methods=['PUT'])
def updateUserInfo():
    request_data = json.loads(request.data)

    valid, user_id = checkValidPostRequest(['user'], request_data)
    if not valid:
        return valid

    profile = User(user_id)
    resp = profile.updateUserInfo(request_data['user'])

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)


@app_user.route('/api/post/auth/delete', methods=['POST'])
def delete():
    request_data = json.loads(request.data)

    valid, user_id = checkValidPostRequest([], request_data)
    if not valid:
        return valid

    profile = User(user_id)
    resp = profile.deleteAccount()

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)
