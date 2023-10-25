import json
import pathlib

from util.errors import NetworkError


def getCurrentUrl():
    return "http://176.126.237.70:3002"


def getGeneralSettings():
    with open("settings.json", "r") as f:
        general_settings = json.loads(f.read())
    return general_settings


def requestBodyContains(keys: list, request_data):
    for key in keys:
        if key not in request_data.keys():
            return False
    return True


def checkValidPostRequest(keys: list, request_data, check_auth=True):
    from api.auth.auth import Auth
    if check_auth:
        keys.append("token")

    if not requestBodyContains(keys, request_data):
        return NetworkError("Request error", "Incomplete request body", code='incomplete_request_body',
                            status=400).getResponse(), False

    if not check_auth:
        return True, False

    auth = Auth()
    user_id = auth.getUserIdByToken(request_data["token"])
    if user_id is None:
        return NetworkError("Authentication error", "Invalid auth token", code='invalid_auth_token',
                            status=404).getResponse(), False

    return True, user_id
