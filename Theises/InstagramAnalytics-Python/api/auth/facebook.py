import requests
import json
from api.auth.auth import Auth
from util.errors import NetworkError


class FacebookAuth(Auth):

    def __init__(self):
        super().__init__()

    @staticmethod
    def __getInfoByToken(token):
        request_url = f'https://graph.facebook.com/me?fields=name,first_name,last_name,email&access_token={token}'
        resp = requests.get(request_url)
        if resp.status_code != 200:
            return None
        else:
            return json.loads(resp.content)

    def createUser(self, facebook_token, platform='unknown'):

        user_details = self.__getInfoByToken(facebook_token)

        if user_details is None:
            return NetworkError("Facebook authentication error", "Error retrieving user details", code="facebook_error")

        # make the names in the request match the ones in the database
        user_details['facebook_id'] = user_details['id']
        user_details['username'] = user_details['name']
        user_details.pop('id')

        facebook_id = user_details['facebook_id']
        request_email = user_details['email']

        # check if the email is already used
        email_is_used = self.selectOne(f"SELECT `user_id` FROM Users WHERE `email` = %s", request_email) is not None

        resp = self.selectOne("SELECT `user_id`, `email` from Users where `facebook_id` = %s", facebook_id)

        # no such facebook user exists
        if resp is None:
            # if no such user exist but the email is used, return None
            if email_is_used:
                return NetworkError("Facebook authentication error", "Email already linked to an account", code="email_in_use")
            # create the new user and get his id
            q = "INSERT INTO Users (`email`, `username`, `facebook_id`, `verified`, `platform`) VALUES (%s, %s, %s, 1, %s)"
            user_id = self.execute(q, (user_details["email"], user_details["username"], user_details['facebook_id'], platform))

        else:
            user_id = resp['user_id']
            # Update user platform
            self.execute("UPDATE Users SET `platform` = %s WHERE user_id = %s", (platform, user_id))

        return {
            "user_id": user_id,
            "token": self.updateSession(user_id),
        }
