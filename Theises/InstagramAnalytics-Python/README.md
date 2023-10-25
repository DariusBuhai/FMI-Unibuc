# Instagram Likes Prediction

As an influencer, growing the number of likes for your Instagram posts and analyzing the number of active followers for your page should be a priority, and using various tools for this can become very helpful.

For that, we will create a mobile app that will predict the number of likes that an Instagram post could receive. For the prediction to work,  we will train a Sequential model on ~200.000 Instagram posts which will be extracted using the api offered by https://developers.facebook.com/docs/instagram-api/ and implemented in  python (https://github.com/ping/instagram_private_api).

The mobile app will be created in Flutter \cite{flutter_dev} and it will include a graphic interface for predicting the number of likes based on a given description, date-time, and image. Also, we will retrieve relevant insights from the user's Instagram profile which will be needed for our prediction (followers and mean likes). 
