from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('news/', views.get_news, name='get_news'),
    path('companies/', views.get_companies, name='get_companies'),
    path('classified_news/<str:company>', views.get_classified_news_by_name, name='get_classified_news_by_name'),
    path('news/<slug:company>', views.get_news_by_name, name='get_news_by_name'),
    path('tweets/<str:company>', views.get_twitter_news_by_name, name='get_twitter_news_by_name'),
    path('classified_tweets/<str:company>', views.get_classified_tweets_by_name, name='get_classified_tweets_by_name'),
    path('stocks/<str:company>', views.get_company_stocks, name='get_company_stocks'),
    path('classified_stocks/<str:company>/<slug:company_s>', views.get_classified_stocks, name='get_classified_stocks'),
    path('predict_headline_stocks/<str:headline>/<int:likes>/<int:shares>/<slug:company>/<slug:company_s>', views.predict_headline_stocks, name='predict_headline_stocks'),
]