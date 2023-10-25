import hashlib
import os
import secrets

from util.database import Database
from util.errors import NetworkError
from validate_email import validate_email

from util.general import getCurrentUrl
from util.mailer import Mailer


class Auth(Database):

    def getUserIdByToken(self, token: str):
        users = self.select(f"SELECT `user_id` FROM Sessions WHERE `token` = '{token}' AND `expiration_date` > CURDATE() AND `type` = 'auth'")
        if len(users) == 0:
            return None
        return users[0]["user_id"]

    def updateSession(self, user_id, session_type='auth'):
        session = self.selectOne("SELECT `session_id` FROM Sessions WHERE `user_id` = %s AND `type` = %s", (user_id, session_type))
        token = secrets.token_hex(16)

        if session is None:
            insertQuery = "INSERT INTO Sessions(`user_id`, `token`, `expiration_date`, `type`) VALUES (%s, %s, CURDATE() + INTERVAL 1 MONTH, %s)"
            self.execute(insertQuery, (user_id, token, session_type))
        else:
            updateQuery = "UPDATE Sessions SET `token` = %s, `expiration_date` = CURDATE() + INTERVAL 1 MONTH where user_id = %s"
            self.execute(updateQuery, (token, user_id))

        return token

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

    def register(self, email, name, password, platform='unknown'):
        if not validate_email(email):
            return NetworkError("Authentication error", "Invalid email", code='invalid_email')

        res = self.selectOne(f"SELECT count(*) as count FROM Users WHERE `email` = %s", email)

        if res['count'] > 0:
            return NetworkError("Authentication error",
                                "There is already an account associated with this email address", code='email_in_use')

        # Create account
        q = "INSERT INTO Users (`email`, `username`, `password`, `verified`, `platform`) VALUES (%s, %s, %s, 1, %s)"
        user_id = self.execute(q, (email, name, self.encodePassword(password), platform))
        token = self.updateSession(user_id, session_type="confirm")

        # Send confirmation mail
        # mailer = Mailer()
        # mailer.sendTemplateMail(email, "confirm-email", {
        #     "name": name,
        #     "user": email,
        #     "link": f"{getCurrentUrl()}/confirm-email?token={token}",
        # }, user_id=user_id)

        return True

    def login(self, username, password, platform="unknown"):
        user = self.selectOne("SELECT `user_id`, `password`, `verified` FROM Users WHERE `email` = %s OR `username` = %s", (username, username))
        if user is None:
            return NetworkError("Authentication error", "No user found", code='user_not_found')
        if user['password'] is None:
            return NetworkError("Authentication error", "User not signed in with email", code='user_auth_error')
        if not user['verified']:
            return NetworkError("Authentication error", "Account not yet verified. Please check your inbox for further instructions.", code='account_not_verified')

        if not self.verifyPassword(password, user["password"]):
            return NetworkError("Authentication error", "Invalid username or password", 402, code='wrong_password')

        user_id = user["user_id"]
        token = self.updateSession(user_id)

        # Update user platform
        self.execute("UPDATE Users SET `platform` = %s WHERE `user_id` = %s", (platform, user_id))

        return {
            "token": token,
            "user_id": user_id
        }

    def logout(self, token):
        self.execute("DELETE FROM Sessions WHERE `token` = %s", token)

    def initReset(self, email, password):
        if len(password) < 10:
            return NetworkError("Error", "Parola trebuie să conțină cel puțin 10 caractere", 404, code='invalid_password_format')
        token = secrets.token_hex(16)
        user = self.selectOne(f"SELECT * FROM Users WHERE `email` = %s", email)
        if user is None:
            return NetworkError("Error", "Nu există niciun utilizator asociat adresei de email", 404, code='user_not_found')
        hashed_password = self.encodePassword(password)

        self.execute("DELETE FROM Sessions WHERE `user_id` = %s AND `type` = 'recover'", user['user_id'])
        self.execute(
            "INSERT INTO Sessions(`user_id`, `token`, `expiration_date`, `type`, `variable`) VALUES (%s, %s, CURDATE() + INTERVAL 1 MONTH, 'recover', %s)",
            (user['user_id'], token, hashed_password))

        mailer = Mailer()
        mailer.sendTemplateMail(email, "recover", {
            "link": f"{getCurrentUrl()}/finish-reset?token={token}",
            "name": user['username'],
            "user": user['email']
        }, user_id=user['user_id'])

        return True

    def finishReset(self, token):
        session = self.selectOne(
            f"SELECT `user_id`, `variable` FROM Sessions WHERE `token` = '{token}' AND `expiration_date` > CURDATE() AND `type` = 'recover'")
        if session is None:
            return NetworkError("Error", "Invalid token", 404, code='invalid_token')

        self.execute(f"DELETE FROM Sessions WHERE `token` = %s", token)
        self.execute(f"UPDATE Users SET `password` = %s WHERE `user_id` = %s", (session['variable'], session['user_id']))

        return True

    def confirmEmail(self, token):
        session = self.selectOne(
            f"SELECT `user_id`, `variable` FROM Sessions WHERE `token` = '{token}' AND `type` = 'confirm'")
        if session is None:
            return NetworkError("Error", "Invalid token", 404, code='invalid_token')

        self.execute(f"DELETE FROM Sessions WHERE `token` = %s", token)
        self.execute(f"UPDATE Users SET `verified` = 1 WHERE `user_id` = %s", session['user_id'])

        return True
