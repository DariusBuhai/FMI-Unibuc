import base64
import json

from flask import Blueprint, request, Response, jsonify, send_file, render_template

from api.auth.apple import AppleAuth
from api.user.user import User
# from api.auth.apple import AppleAuth
from api.auth.auth import Auth
from api.auth.facebook import FacebookAuth

from util.errors import NetworkError
from util.general import requestBodyContains, checkValidPostRequest

app_auth = Blueprint('auth', __name__)


# Pages
@app_auth.route('/finish-reset', methods=['GET'])
def finishResetPage():
    token = request.args.get("token", None)
    auth = Auth()
    resp = auth.finishReset(token)

    if type(resp) is NetworkError:
        return resp.getHtmlResponse()

    return render_template(
        "page-message.html",
        title="Password updated",
        message="Your password has been successfully updated",
    )


@app_auth.route('/confirm-email', methods=['GET'])
def confirmEmailPage():
    token = request.args.get("token", None)
    auth = Auth()
    resp = auth.confirmEmail(token)

    if type(resp) is NetworkError:
        return resp.getHtmlResponse()

    return render_template(
        "page-message.html",
        title="Account confirmed",
        message="Your account has been confirmed",
    )


# API
@app_auth.route('/api/post/auth/facebook', methods=['POST'])
def facebookAuth():
    request_data = json.loads(request.data)

    if not requestBodyContains(["token"], request_data):
        return NetworkError("Request error", "Incomplete request body", status=400,
                            code='incomplete_request_body').getResponse()

    facebook_auth = FacebookAuth()
    platform = request_data["platform"] if "platform" in request_data else 'unknown'
    resp = facebook_auth.createUser(request_data['token'], platform)

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)


@app_auth.route('/api/post/auth/apple', methods=['POST'])
def appleAuth():
    request_data = json.loads(request.data)

    if not requestBodyContains(["token"], request_data):
        return NetworkError("Request error", "Incomplete request body", status=400,
                            code='incomplete_request_body').getResponse()

    apple_auth = AppleAuth()
    platform = request_data["platform"] if "platform" in request_data else 'unknown'
    resp = apple_auth.createUser(request_data['token'], request_data['username'], platform)

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)


@app_auth.route('/api/get/auth/user', methods=['GET'])
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


@app_auth.route('/api/post/auth/register', methods=['POST'])
def register():
    request_data = json.loads(request.data)

    if not requestBodyContains(["email", "password", "name"], request_data):
        return NetworkError("Request error", "Incomplete request body", status=400,
                            code='incomplete_request_body').getResponse()

    auth = Auth()
    platform = request_data["platform"] if "platform" in request_data else 'unknown'
    resp = auth.register(request_data['email'], request_data['name'], request_data['password'], platform)

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)


@app_auth.route('/api/post/auth/login', methods=['POST'])
def login():
    request_data = json.loads(request.data)

    if not requestBodyContains(["username", "password"], request_data):
        return NetworkError("Request error", "Incomplete request body", status=400,
                            code='incomplete_request_body').getResponse()

    auth = Auth()
    platform = request_data["platform"] if "platform" in request_data else 'unknown'
    resp = auth.login(request_data['username'], request_data['password'], platform)

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)


@app_auth.route('/api/post/auth/logout', methods=['POST'])
def logout():
    request_data = json.loads(request.data)

    if not requestBodyContains(["token"], request_data):
        return NetworkError("Request error", "Incomplete request body", status=400,
                            code='incomplete_request_body').getResponse()

    auth = Auth()
    resp = auth.logout(request_data["token"])

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)


@app_auth.route('/api/put/auth/reset_password', methods=['PUT', 'POST'])
def resetPassword():
    request_data = json.loads(request.data)

    if not requestBodyContains(["email", "password"], request_data):
        return NetworkError("Request error", "Incomplete request body", status=400,
                            code='incomplete_request_body').getResponse()

    auth = Auth()
    resp = auth.initReset(request_data["email"], request_data["password"])

    if type(resp) is NetworkError:
        return resp.getResponse()

    return jsonify(resp)
