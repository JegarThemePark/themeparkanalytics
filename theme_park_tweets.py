# I copied all this stuff from http://adilmoujahid.com/posts/2014/07/twitter-analytics/ - check out Adil's blog if you get a chance!

#Import the necessary methods from tweepy library
import re
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
import os

#Variables that contains the user credentials to access Twitter API
access_token =  os.environ.get("twitter_access_token")
access_token_secret =  os.environ.get("twitter_secret_token")
consumer_key =  os.environ.get("twitter_consumer_key")
consumer_secret =  os.environ.get("twitter_consumer_secret")


#This is a basic listener that just prints received tweets to stdout.
class StdOutListener(StreamListener):

    def on_data(self, data):
        print data
        return True

    def on_error(self, status):
        print status



if __name__ == '__main__':

    #This handles Twitter authentification and the connection to Twitter Streaming API
    l = StdOutListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    stream = Stream(auth, l)
    #This line filter Twitter Streams to capture data by the keywords: 'python', 'javascript', 'ruby'
    stream.filter(track= [ "#Disneyland", "#universalstudios", "#universalstudiosFlorida", "#UniversalStudiosFlorida", "#universalstudioslorida", "#magickingdom", "#Epcot","#EPCOT","#epcot", "#animalkingdom", "#AnimalKingdom", "#disneyworld", "#DisneyWorld", "Disney's Hollywood Studios", "#Efteling", "#efteling", "De Efteling", "Universal Studios Japan", "#WDW", "#dubaiparksandresorts", "#harrypotterworld", "#disneyland", "#UniversalStudios", "#waltdisneyworld", "#disneylandparis", "#tokyodisneyland", "#themepark"])
