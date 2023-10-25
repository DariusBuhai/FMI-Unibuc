from datetime import datetime

import pandas as pd
from prediction.features_extraction import FeaturesExtraction
from prediction.image_features_extraction import ImageFeaturesExtraction
from prediction.preprocessing import Preprocessing
from prediction.regressor import Regressor
from util.database import Database


class PredictionApi(Database):
    @staticmethod
    def predictPostLikes(date_time: datetime, description: str, followers: int = 0, faces: int = 0,
                         smiles: int = 0, mean_likes=None):
        post = {
            "smiles": smiles,
            "faces": faces,
            "followers": followers,
            "description": description,
            "taken_at": datetime.timestamp(date_time),
        }
        posts = Preprocessing.preprocessPosts(pd.DataFrame([post]))
        features_extraction = FeaturesExtraction(posts)
        posts = features_extraction.extractPostsFeatures()
        regressor = Regressor(prediction_mode=True)
        regressor.loadModel()
        response = regressor.predict(posts.iloc[0])
        if mean_likes is not None:
            return round(float(response) * float(mean_likes)), round(float(response), 3)
        return None, round(float(response), 3)


if __name__ == "__main__":
    likes, _ = PredictionApi.predictPostLikes(datetime.fromtimestamp(1654156666),
                                              "I love this day. Best day of my life!", 760, 1, 1, mean_likes=150)
    print(f"{round(likes)} likes")
