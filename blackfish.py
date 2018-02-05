import re
import tweepy as tp
import os

# Variables that contains the user credentials to access Twitter API
access_token =  os.environ.get("twitter_access_token")
access_token_secret =  os.environ.get("twitter_secret_token")
consumer_key =  os.environ.get("twitter_consumer_key")
consumer_secret =  os.environ.get("twitter_consumer_secret")


auth = tp.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)


# results = api.GetSearch(
#     raw_query="https://twitter.com/search?l=&q=blackfish%20OR%20seaworld%20%23blackfish%20OR%20%23seaworld%20since%3A2011-11-19%20until%3A2017-11-19")

api = tp.API(auth)

query = 'blackfish seaworld'
max_tweets = 10
searched_tweets = [status for status in tp.Cursor(api.search, q=query).items(max_tweets)]

print searched_tweets
