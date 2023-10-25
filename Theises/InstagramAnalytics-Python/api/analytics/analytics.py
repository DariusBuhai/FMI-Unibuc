import codecs
import datetime
import json

from util.database import Database
from vendor.instagram_private_api import Client

from api.user.user import User
from util.errors import NetworkError
import platform
import os
import ssl
import certifi


class Analytics(Database):

    def __init__(self):
        super().__init__()
        self.api: Client = None
        self.connectAccount(self.general_settings['instagram_account']['username'],
                            self.general_settings['instagram_account']['password'])

    @staticmethod
    def to_json(python_object):
        if isinstance(python_object, bytes):
            return {'__class__': 'bytes',
                    '__value__': codecs.encode(python_object, 'base64').decode()}
        raise TypeError(repr(python_object) + ' is not JSON serializable')

    @staticmethod
    def from_json(json_object):
        if '__class__' in json_object and json_object['__class__'] == 'bytes':
            return codecs.decode(json_object['__value__'].encode(), 'base64')
        return json_object

    def onLoginCallback(self, api, username):
        cache_settings = api.settings
        self.execute("DELETE FROM InstagramTokens WHERE `username` = %s", (self.user_id, username))
        self.insert("InstagramAccounts", {
            "username": username,
            "token": json.dumps(cache_settings, default=self.to_json)
        })

    def connectAccount(self, username, password=None):
        ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
        ssl_context.verify_mode = ssl.CERT_REQUIRED
        ssl_context.check_hostname = True
        ssl_context.load_default_certs()

        if platform.system().lower() == 'darwin':
            ssl_context.load_verify_locations(
                cafile=os.path.relpath(certifi.where()),
                capath=None,
                cadata=None)

        saved_account = self.selectOne("SELECT * FROM InstagramTokens WHERE `username` = %s ORDER BY `id` DESC LIMIT 1",
                                       username)
        if saved_account is not None:
            try:
                cache_settings = json.loads(saved_account['token'], object_hook=self.from_json)
                self.api = Client(auto_patch=True, drop_incompat_keys=False, username=username, password=password,
                                  settings=cache_settings, custom_ssl_context=ssl_context)
                return True
            except Exception:
                print("Cannot import old account")
                pass
        if password is None:
            return NetworkError(title="Cannot connect to account", message="No password given")
        self.api = Client(auto_patch=True, drop_incompat_keys=False, username=username, password=password,
                          on_login=lambda x: self.onLoginCallback(x, username), custom_ssl_context=ssl_context)
        return True

    def getAccountDetails(self, user_id, username):
        account = self.selectOne(
            "SELECT `username`, `followers`, `following`, `posts_count`, `median_likes`, `uid` FROM InstagramAccounts WHERE `user_id` = %s ORDER BY `updated` DESC LIMIT 1",
            user_id)

        if account is None or (username is not None and username != "" and username!=account['username']):
            if username is None or username == "":
                return NetworkError("No username provided", "No username has been provided")
            try:
                return self.getUpdateAccountDetails(user_id, username)
            except:
                return NetworkError("Invalid username", "Cannot retrieve account. The username is either invalid or the account is private.")
        return account

    def getUpdateAccountDetails(self, user_id, username):
        username_info = self.api.username_info(username)['user']
        user_feed = self.api.username_feed(user_name=username, count=64)['items']

        all_likes = [x['likes']['count'] for x in user_feed]
        median_likes = sum(all_likes) / len(all_likes)
        self.insert("InstagramAccounts", {
            "user_id": user_id,
            "username": username,
            "followers": username_info['follower_count'],
            "following": username_info['following_count'],
            "posts_count": username_info['counts']['media'],
            "median_likes": round(median_likes),
            "uid": username_info['id'],
            "feed": json.dumps(user_feed)
        }, check_table_column=False)

        return {
            "username": username,
            "followers": username_info['follower_count'],
            "following": username_info['following_count'],
            "posts_count": username_info['counts']['media'],
            "median_likes": round(median_likes),
            "uid": username_info['id']
        }


if __name__ == "__main__":
    analytics = Analytics()
    print(analytics.getAccountDetails(1, "dariusbuhai"))
