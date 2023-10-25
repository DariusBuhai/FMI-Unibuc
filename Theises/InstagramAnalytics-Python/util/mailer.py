
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from api.user.user import User
from util.database import Database
from util.general import getGeneralSettings


class Mailer(Database):
    def __init__(self):
        self.server = None
        self.general_settings = getGeneralSettings()
        self.initializeConnection()
        super().__init__()

    def __del__(self):
        if self.server is not None:
            self.server.quit()
            self.server = None
        pass

    def initializeConnection(self):
        smtp_server = self.general_settings['mail']['host']
        port = self.general_settings['mail']['port']
        sender_email = self.general_settings['mail']['username']
        password = self.general_settings['mail']['password']

        try:
            self.server = smtplib.SMTP_SSL(smtp_server, port)
            self.server.ehlo()
            self.server.login(sender_email, password)
        except Exception as e:
            print(e)

    def sendMail(self, receiver, subject, content, html_content=None, attachments=None):

        if attachments is None:
            attachments = []
        if html_content is None:
            html_content = content

        message = MIMEMultipart("alternative")
        message["Subject"] = subject
        message["From"] = self.general_settings['mail']['username']
        message["To"] = receiver

        part1 = MIMEText(content, "plain")
        part2 = MIMEText(html_content, "html")

        message.attach(part1)
        message.attach(part2)

        for attachment in attachments:
            message.attach(MIMEMultipart(attachment))

        try:
            self.server.sendmail(self.general_settings['mail']['username'], receiver, message.as_string())
        except Exception as e:
            print(e)

        return True

    def sendTemplateMail(self, receiver, template_name, values: dict, attachments=None, user_id=None):
        if attachments is None:
            attachments = []

        # Switch to user database and select mail details
        profile_class = User(user_id)
        self.useDatabase(profile_class.getDatabase())
        email_details = self.selectOne("SELECT * FROM EmailTemplates WHERE `type` = %s", template_name)
        self.useDatabase()
        if email_details is None:
            return False
        subject = email_details['subject']
        message = email_details['message']

        for key in values.keys():
            message = message.replace(f"[{key}]", values[key])

        html_message = message

        return self.sendMail(receiver, subject, message, html_content=html_message, attachments=attachments)
