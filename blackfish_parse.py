import twitter
import json
import pandas as pd
import matplotlib.pyplot as plt
from textblob import TextBlob
import re
import os

# These functions come from  https://github.com/adilmoujahid/Twitter_Analytics/blob/master/analyze_tweets.py and http://www.geeksforgeeks.org/twitter-sentiment-analysis-using-python//

def extract_link(text):
    """
    This function removes any links in the tweet - we'll put them back more cleanly later
    """
    regex = r'https?://[^\s<>"]+|www\.[^\s<>"]+'
    match = re.search(regex, text)
    if match:
        return match.group()
    return ''

def word_in_text(word, text):
    """
    Use regex to figure out which park or ride they're talking about.
    I might use this in future in combination with my wikipedia scraping script.
    """
    word = word.lower()
    text = text.lower()
    match = re.search(word, text, re.I)
    if match:
        return True
    return False

def clean_tweet(tweet):
        '''
        Utility function to clean tweet text by removing links, special characters
        using simple regex statements.
        '''
        return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())

def get_tweet_sentiment(tweet):
    '''
    Utility function to classify sentiment of passed tweet
    using textblob's sentiment method
    '''
    # create TextBlob object of passed tweet text
    analysis = TextBlob(clean_tweet(tweet))
    # set sentiment
    if analysis.sentiment.polarity > 0:
        return 'positive'
    elif analysis.sentiment.polarity == 0:
        return 'neutral'
    else:
        return 'negative'


api = twitter.Api(consumer_key=os.environ.get("twitter_consumer_key"),
                  consumer_secret=os.environ.get("twitter_consumer_secret"),
                  access_token_key= os.environ.get("twitter_access_token"),
                  access_token_secret=os.environ.get("twitter_secret_token"))
# Load up the file generated from the Twitter stream capture.
# # I've assumed it's loaded in a folder called data which I won't upload because git.
tweets_data_path = '../data/blackfish_tweets.txt'
results = api.GetSearch(
     raw_query="l=&q=blackfish%20OR%20seaworld%20since%3A2011-11-19%20until%3A2011-11-20" )
print results

# tweets_data = []
# tweets_file = open(tweets_data_path, "r")
# for line in tweets_file:
#     print line
#     # for thing in line:
#     #     print thing
# # Check you've created a list that actually has a length. Huzzah!


# Turn the tweets_data list into a Pandas DataFrame with a wide section of True/False for which park they talk about
# (Adaped from https://github.com/adilmoujahid/Twitter_Analytics/blob/master/analyze_tweets.py)
# tweets = pd.DataFrame()
# tweets['user_name'] = map(lambda tweet: tweet['user']['name'] if tweet['user'] != None else None, tweets_data)
# tweets['followers'] = map(lambda tweet: tweet['user']['followers_count'] if tweet['user'] != None else None, tweets_data)
# tweets['text'] = map(lambda tweet: tweet['text'], tweets_data)
# tweets['retweets'] = map(lambda tweet: tweet['retweet_count'], tweets_data)
# tweets['blackfish'] = tweets['text'].apply(lambda tweet: word_in_text(r'blackfish', tweet))
# tweets['link'] = tweets['text'].apply(lambda tweet: extract_link(tweet))
# tweets['sentiment'] = tweets['text'].apply(lambda tweet: get_tweet_sentiment(tweet))
#
# # I want to add in a column called 'park' as well that will list which park is being talked about, and add an entry for 'unknown'
# # I'm 100% sure there's a better way to do this...
#
# print tweets

# Create a dataset that will be used in a graph of tweet count by park
# parks = ['disney', 'universal', 'efteling']
# tweets_by_park = [tweets['disney'].value_counts()[True], tweets['universal'].value_counts()[True], tweets['efteling'].value_counts()[True]]
# x_pos = list(range(len(parks)))
# width = 0.8
# fig, ax = plt.subplots()
# plt.bar(x_pos, tweets_by_park, width, alpha=1, color='g')
#
# # Set axis labels and ticks
# ax.set_ylabel('Number of tweets', fontsize=15)
# ax.set_title('Tweet Frequency: disney vs. universal vs. efteling', fontsize=10, fontweight='bold')
# ax.set_xticks([p + 0.4 * width for p in x_pos])
# ax.set_xticklabels(parks)
# # You need to write this for the graph to actually appear.
# plt.show()
#
# # Create a graph of the proportion of postive, negative and neutral tweets for each park
# # I have to do two groupby's here because I want proportion within each park, not global proportions.
# sent_by_park = tweets.groupby(['park', 'sentiment']).size().groupby(level = 0).transform(lambda x: x/x.sum()).unstack()
# sent_by_park.plot(kind = 'bar' )
# plt.title('Tweet Sentiment proportions by park')
# plt.show()
