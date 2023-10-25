import hashlib
import os
from io import BytesIO

from util.database import Database
from util.errors import NetworkError


class User(Database):

    def __init__(self, user_id):
        super().__init__()
        self.user_id = user_id
        self.user = self.getUser()

    @staticmethod
    def encodePassword(password):
        salt = os.urandom(32)
        key = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt, 100000)
        return str(salt + key, encoding='raw_unicode_escape')

    @staticmethod
    def verifyPassword(password, hashed_password):
        storage = bytes(hashed_password, encoding="raw_unicode_escape")
        hashed_password = storage[32:]
        salt = bytes(storage[:32])
        key = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt, 100000)
        return key == hashed_password

    def getUser(self):
        # Get User
        user = self.selectOne("SELECT * FROM Users WHERE user_id = %s", self.user_id)
        if user is None:
            return None

        # Determine login type
        if user['password'] is not None:
            user['login_type'] = 'email'
        elif user['facebook_id'] is not None:
            user['login_type'] = 'facebook'
        elif user['apple_id'] is not None:
            user['login_type'] = 'apple'
        elif user['linkedin_id'] is not None:
            user['login_type'] = 'linkedin'
        return user

    def getUserImage(self):
        if self.user['image_id'] is None:
            return None

        image_id = self.user['image_id']
        path = self.selectOne("SELECT `path` FROM Images where `image_id` = %s", image_id)
        if path is None:
            return None
        return path['path']

    def addUserImage(self, image):
        image_id = None
        if self.user['image_id'] is not None:
            image_id = self.user['image_id']
            count = self.selectOne("SELECT count(*) as c FROM Images WHERE image_id = %s", image_id)['c']
            if count == 0:
                image_id = None
        if image_id is None:
            image_id = self.execute("INSERT INTO Images (`user_id`) VALUES (%s)", self.user_id)
        self.execute("UPDATE Users SET `image_id` = %s WHERE `user_id` = %s", (image_id, self.user_id))

        image_path = f"user-data/image-{image_id}.jpeg"
        with open(image_path, "wb") as f:
            f.write(image)
        self.execute("UPDATE Images SET `path` = %s WHERE `image_id` = %s", (image_path, image_id))
        return True

    def changePassword(self, old_password, new_password):
        if not self.verifyPassword(old_password, self.user["password"]):
            return NetworkError("Verification error", "Incorrect password", status=402, code='wrong_password')

        hashed_new_password = self.encodePassword(new_password)
        self.execute("UPDATE Users SET `password` = %s WHERE `user_id` = %s", (hashed_new_password, self.user_id))
        return True

    def updateUserInfo(self, data):
        self.update('Users', data, {'user_id': self.user_id}, filter_data=[
            'username'
        ])
        return data

    def deleteAccount(self):
        self.execute("DELETE FROM Sessions WHERE `user_id` = '%s'", self.user_id)
        self.execute("DELETE FROM Users WHERE `user_id` = '%s'", self.user_id)
        self.execute("DELETE FROM Images WHERE `user_id` = '%s'", self.user_id)

    def getCurrency(self):
        if self.user['country'] == 'ro':
            return '[price] lei'
        return '$[price]'

    def getDatabase(self):
        if self.user["country"] == "ro":
            return "estimator_ar_ro"
        return "estimator_ar_us"

    def useUserDatabase(self):
        database = self.getDatabase()
        self.useDatabase(database)

