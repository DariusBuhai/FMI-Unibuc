import pathlib

import cv2
import pandas as pd
import requests


def getCurrentPath():
    return f"{pathlib.Path(__file__).parent.resolve()}/"


class Person:
    def __init__(self, smiles: bool = False, eyes: int = 0):
        self.smiles: bool = smiles
        self.eyes: int = eyes


class Features:
    def __init__(self, persons: list[Person], dogs: int = 0, cats: int = 0):
        self.persons: list[Person] = persons
        self.dogs: int = dogs
        self.cats: int = cats

    def toJson(self):
        return {
            "faces": len(self.persons),
            "smiles": sum([1 if x.smiles else 0 for x in self.persons]),
        }


class ImageFeaturesExtraction:
    PREV_POSTS_FILE = "../data/posts.csv"
    CURRENT_POSTS_FILE = "../data/posts_image_features.csv"
    TEMP_IMAGES_PATH = "../../temp-data"

    @staticmethod
    def getImagePathFeatures(image_path) -> Features:
        # Read the image
        image = cv2.imread(image_path)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

        faceCascade = cv2.CascadeClassifier(f"{getCurrentPath()}haarscascades/frontalface.xml")
        smileCascade = cv2.CascadeClassifier(f"{getCurrentPath()}haarscascades/smile.xml")
        eyesCascade = cv2.CascadeClassifier(f"{getCurrentPath()}haarscascades/eye.xml")

        persons: list[Person] = list()

        # Detect faces in the image
        faces = faceCascade.detectMultiScale(gray, scaleFactor=1.3, minNeighbors=6, minSize=(30, 30))
        for (x, y, w, h) in faces:
            cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)
            face_cropped_gray = gray[y:y + h, x:x + w]

            # Detect smiles in the image
            smiles = smileCascade.detectMultiScale(face_cropped_gray, scaleFactor=2, minNeighbors=10)
            for (x_s, y_s, w_s, h_s) in smiles:
                cv2.rectangle(image, (x_s + x, y_s + y), (x_s + x + w_s, y_s + y + h_s), (255, 0, 0), 2)

            # Detect eyes in the image
            eyes = eyesCascade.detectMultiScale(face_cropped_gray, scaleFactor=2)

            # for (x_s, y_s, w_s, h_s) in eyes:
            #     cv2.rectangle(image, (x_s + x, y_s + y), (x_s + x + w_s, y_s + y + h_s), (0, 0, 255), 2)

            persons.append(Person(smiles=len(smiles) > 0, eyes=max(2, len(eyes))))

        cv2.imwrite(f"{getCurrentPath()}{ImageFeaturesExtraction.TEMP_IMAGES_PATH}/image-detect.jpeg", image)

        return Features(
            persons=persons,
        )

    @staticmethod
    def getUrlFeatures(url):
        resp = requests.get(url)
        ext = "jpeg"
        if resp.headers['Content-type'] == "image/jpeg":
            ext = "jpeg"
        elif resp.headers['Content-type'] == "image/png":
            ext = "png"
        im_path = f"{getCurrentPath()}{ImageFeaturesExtraction.TEMP_IMAGES_PATH}/image.{ext}"
        with open(f"{getCurrentPath()}{ImageFeaturesExtraction.TEMP_IMAGES_PATH}/image.{ext}", "wb") as i:
            i.write(resp.content)
        features = ImageFeaturesExtraction.getImagePathFeatures(im_path)
        # os.remove(im_path)
        return features

    @staticmethod
    def getImageFeatures(image, ext="jpeg"):
        im_path = f"{getCurrentPath()}{ImageFeaturesExtraction.TEMP_IMAGES_PATH}/image.{ext}"
        with open(f"{getCurrentPath()}{ImageFeaturesExtraction.TEMP_IMAGES_PATH}/image.{ext}", "wb") as i:
            i.write(image)
        features = ImageFeaturesExtraction.getImagePathFeatures(im_path)
        with open(f"{getCurrentPath()}{ImageFeaturesExtraction.TEMP_IMAGES_PATH}/image-detect.jpeg", "rb") as i:
            new_image = i.read()
        return features, new_image

    @staticmethod
    def extractPostsImageFeatures():
        updated_posts = []
        posts = pd.read_csv(ImageFeaturesExtraction.PREV_POSTS_FILE)
        for idx, post in posts.iterrows():
            try:
                features = ImageFeaturesExtraction.getUrlFeatures(post['image_url'])
                post['smiles'] = features.toJson()['smiles']
                post['faces'] = features.toJson()['faces']
                print(f"{idx} - ok; {post['faces']} faces, {post['smiles']} smiles")
            except Exception as e:
                print(f"{idx} - {e}")
                pass
            updated_posts.append(post)
        updated_posts = pd.DataFrame(updated_posts)
        updated_posts.to_csv(ImageFeaturesExtraction.CURRENT_POSTS_FILE)


if __name__ == "__main__":
    ImageFeaturesExtraction.extractPostsImageFeatures()
    # ImageFeaturesExtraction.getUrlFeatures("https://s.iw.ro/gateway/g/ZmlsZVNvdXJjZT1odHRwJTNBJTJGJTJG/c3RvcmFnZTAxdHJhbnNjb2Rlci5yY3Mt/cmRzLnJvJTJGc3RvcmFnZSUyRjIwMTcl/MkYxMSUyRjA5JTJGODQyNTUyXzg0MjU1/Ml9uZXlfNF8uanBnJnc9NzAwJmg9NDIw/Jmhhc2g9MWJlOWVlYWIzYzI5MzVkNDgwZjkzNDhiMjE1ZDZlYjE=.thumb.jpg")
