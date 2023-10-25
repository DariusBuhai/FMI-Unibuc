import json
from time import time
import requests
from jwt import get_unverified_header, decode, exceptions

from api.auth.auth import Auth
from util.errors import NetworkError


class AppleAuth(Auth):

    APPLE_PUBLIC_KEY_URL = "https://appleid.apple.com/auth/keys"
    APPLE_KEY_CACHE_EXP = 60 * 60 * 24
    APPLE_APP_ID = "com.dariusbuhai.stocknews"

    def __init__(self):
        super().__init__()

    @staticmethod
    def __fetchApplePublicKey(header):
        from jwt.algorithms import RSAAlgorithm
        apple_last_key_fetch = 0
        apple_public_key = None
        if (apple_last_key_fetch + AppleAuth.APPLE_KEY_CACHE_EXP) < int(time()) or apple_public_key is None:
            keys_payload = requests.get(AppleAuth.APPLE_PUBLIC_KEY_URL).json()
            for key_payload in keys_payload['keys']:
                if key_payload['kid'] == header['kid']:
                    apple_public_key = RSAAlgorithm.from_jwk(json.dumps(key_payload))
                    return apple_public_key
        return NetworkError("Apple authentication error", "Cannot find kid", code='cannot_find_kid')

    @staticmethod
    def __decodeAppleUserToken(apple_user_token):
        header = get_unverified_header(apple_user_token)
        public_key = AppleAuth.__fetchApplePublicKey(header)

        if type(public_key) is NetworkError:
            return public_key

        try:
            token = decode(apple_user_token, public_key, audience=AppleAuth.APPLE_APP_ID, algorithms=[header["alg"]])
        except exceptions.ExpiredSignatureError as e:
            return NetworkError("Apple authentication error", "That token has expired", code='apple_token_expired')
        except exceptions.InvalidAudienceError as e:
            return NetworkError("Apple authentication error", f"That token's audience did not match", code='apple_token_not_matched')
        except Exception as e:
            print(e)
            return NetworkError("Apple authentication error", f"An unexpected error occoured: {e}", code='apple_error')
        return token

    @staticmethod
    def __getInfoByToken(user_token):
        token = AppleAuth.__decodeAppleUserToken(user_token)
        if type(token) is NetworkError:
            return token
        apple_user = {
            "apple_id": token["sub"],
            "email": token.get("email", None)
        }
        return apple_user

    def createUser(self, apple_token, username, platform='unknown', country='us'):

        user_details = self.__getInfoByToken(apple_token)

        if user_details is None:
            return NetworkError("Apple authentication error", "Error retrieving user details", code='apple_error')
        if type(user_details) is NetworkError:
            return user_details

        apple_id = user_details['apple_id']
        request_email = user_details['email']
        user_details['username'] = username

        # check if the email is already used
        email_is_used = self.selectOne(f"SELECT `user_id` FROM Users WHERE `email` = %s", request_email) is not None

        resp = self.selectOne("SELECT `user_id`, `email` FROM Users WHERE `apple_id` = %s", apple_id)

        # no such facebook user exists
        if resp is None:
            # if no such user exist but the email is used, return None
            if email_is_used:
                return NetworkError("Apple authentication error", "Email already linked to an account", code='email_in_use')
            # create the new user and get his id
            q = "INSERT INTO Users (`email`, `username`, `apple_id`, `verified`, `platform`) VALUES (%s, %s, %s, 1, %s)"
            user_id = self.execute(q, (user_details["email"], user_details["username"], user_details['apple_id'], platform))
        else:
            user_id = resp['user_id']
            # Update user platform
            self.execute("UPDATE Users SET `platform` = %s WHERE `user_id` = %s", (platform, user_id))

        return {
            "user_id": user_id,
            "token": self.updateSession(user_id),
        }
