import codecs
import json
import os
from time import sleep

import pandas as pd
from instagram_private_api import Client


class DataExtraction:
    CURRENT_POSTS_PATH = "../data/posts/"
    CURRENT_POSTS_FILE = "../data/posts.csv"
    ACCOUNTS_FILE = "../data/accounts.csv"
    AUTH_SETTINGS_FILE = "../data/auth-settings.json"

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

    @staticmethod
    def onlogin_callback(api, new_settings_file):
        cache_settings = api.settings
        with open(new_settings_file, 'w') as outfile:
            json.dump(cache_settings, outfile, default=DataExtraction.to_json)
            print('SAVED: {0!s}'.format(new_settings_file))

    def __init__(self):

        with open("../../settings.json", "r") as f:
            general_settings = json.loads(f.read())
            self.CLIENT_USERNAME = general_settings['instagram_account']['username']
            self.CLIENT_PASSWORD = general_settings['instagram_account']['password']

        try:
            if not os.path.isfile(self.AUTH_SETTINGS_FILE):
                self.api = Client(auto_patch=True, drop_incompat_keys=False, username=self.CLIENT_USERNAME,
                                  password=self.CLIENT_PASSWORD,
                                  on_login=lambda x: self.onlogin_callback(x, self.AUTH_SETTINGS_FILE))
            else:
                print("Reusing auth settings")
                with open(self.AUTH_SETTINGS_FILE) as file_data:
                    cached_settings = json.load(file_data, object_hook=self.from_json)
                self.api = Client(auto_patch=True, drop_incompat_keys=False, username=self.CLIENT_USERNAME,
                                  password=self.CLIENT_PASSWORD, settings=cached_settings)
        except Exception as e:
            print(e)
            self.api = Client(auto_patch=True, drop_incompat_keys=False, username=self.CLIENT_USERNAME,
                              password=self.CLIENT_PASSWORD,
                              on_login=lambda x: self.onlogin_callback(x, self.AUTH_SETTINGS_FILE))

    @staticmethod
    def extractOnlyImportantData():
        all_posts = []
        accounts = pd.read_csv(DataExtraction.ACCOUNTS_FILE)
        for idx, account in accounts.iterrows():
            username = account['Account']
            filepath = f"{DataExtraction.CURRENT_POSTS_PATH}@{username}.csv"
            if not os.path.exists(filepath):
                continue
            user_posts = pd.read_csv(filepath)
            print(f"Found {user_posts.shape[0]} posts for {username}")
            for _, post in user_posts.iterrows():
                image_path = None
                try:
                    images_paths = json.loads(post['images'].replace("'", '"'))
                    image_path = images_paths['low_resolution']['url']
                except Exception as e:
                    pass
                all_posts.append({
                    "username": username,
                    "followers": account['Followers'],
                    "engagement": account['Authentic engagement'],
                    "description": post['description'],
                    "taken_at": post['taken_at'],
                    "image_url": image_path,
                    "likes": post['like_count'],
                    "comments": post['comment_count'],
                })
        all_posts = pd.DataFrame(all_posts)
        print(f"\nTotal posts found: {all_posts.shape[0]}")
        all_posts.to_csv(DataExtraction.CURRENT_POSTS_FILE)

    def getInstagramPosts(self, ig_username, limit_posts=64):
        ig_posts = []

        last_max_id = None
        print(f"Loading @{ig_username}: [", end="")
        while limit_posts > 0:
            try:
                user_feed_info = self.api.username_feed(user_name=ig_username, count=64, max_id=last_max_id)
                current_posts = user_feed_info['items']
                for post in current_posts:
                    post['description'] = ""
                    if post['caption'] is not None and 'text' in post['caption']:
                        post['description'] = post['caption']['text']
                ig_posts.extend(current_posts)
                limit_posts -= user_feed_info['num_results']
                if not user_feed_info['more_available']:
                    break
                if 'next_max_id' not in user_feed_info:
                    break
                last_max_id = user_feed_info['next_max_id']
                print("#", end="")
            except Exception as e:
                print(e)
                return ig_posts
        print("]")
        return ig_posts

    def saveInstagramAccountsPosts(self):
        accounts = pd.read_csv(self.ACCOUNTS_FILE)
        for idx, account in accounts.iterrows():
            should_repeat = True
            while should_repeat:
                should_repeat = False
                try:
                    username = account['Account']
                    filepath = f"{self.CURRENT_POSTS_PATH}@{username}.csv"
                    if os.path.exists(filepath):
                        continue
                    posts = self.getInstagramPosts(username, limit_posts=2000)
                    if len(posts) == 0:
                        print("No posts found")
                        return
                    posts_pd = pd.DataFrame(posts)
                    posts_pd = posts_pd[posts_pd.columns[posts_pd.columns.isin([
                        'id', 'taken_at', 'media_type', 'is_unified_video', 'is_paid_partnership', 'next_max_id',
                        'comment_count',
                        'like_count', 'title', 'link', 'images', 'description', 'original_width', 'original_height'])]]

                    posts_pd.to_csv(filepath)
                    print(f"Saved {username} to {filepath}")
                except Exception as e:
                    print(e)
                    return


def showTimeout(seconds=10):
    print("Timeout: ", end="")
    while seconds > 0:
        sleep(1)
        print(f"{seconds}s/", end="")
        seconds -= 1
    sleep(1)
    print("0s\n")


if __name__ == "__main__":
    data_extraction_client = DataExtraction()
    data_extraction_client.saveInstagramAccountsPosts()
    DataExtraction.extractOnlyImportantData()
