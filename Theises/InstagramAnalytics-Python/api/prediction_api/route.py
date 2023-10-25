import base64

from flask import Blueprint, request, jsonify, Response
from datetime import datetime

from api.prediction_api.prediction_api import PredictionApi
from prediction.image_features_extraction import ImageFeaturesExtraction

app_prediction_api = Blueprint('prediction_api', __name__)


# API
@app_prediction_api.route('/api/get/predict_likes', methods=['GET'])
def predictLikes():
    date_time = datetime.fromtimestamp(int(request.args.get("datetime", datetime.now().timestamp())))
    description = request.args.get("description", "")
    followers = int(request.args.get("followers", 0))
    faces = int(request.args.get("faces", 0))
    smiles = int(request.args.get("smiles", 0))
    mean_likes = request.args.get("mean_likes", None)

    likes, likes_over_mean = PredictionApi.predictPostLikes(date_time, description, followers, faces, smiles,
                                                            mean_likes=mean_likes)

    return jsonify({
        "likes": likes,
        "likes_over_mean": likes_over_mean
    })


@app_prediction_api.route('/api/post/analyse_image', methods=['POST'])
def analyseImage():
    image = base64.b64decode(request.data)

    features, new_image = ImageFeaturesExtraction.getImageFeatures(image)

    return jsonify({
        "features": features.toJson(),
        "image": base64.b64encode(new_image).decode('UTF-8')
    })
