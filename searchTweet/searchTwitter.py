import sys
from TwitterAPI import TwitterAPI
# library github: https://github.com/geduldig/TwitterAPI

def searchTwitter(term):
    SEARCH_TERM = str(term)

    api = TwitterAPI(<consumer key>, 
                     <consumer secret>,
                     <access token key>,
                     <access token secret>)

    r = api.request('search/tweets', {'q': SEARCH_TERM})

    tweetlist = []
    for item in r:
        content = (item['text'] if 'text' in item else item)
        date = (item['created_at'] if 'created_at' in item else item)
        tweetlist.append("{}\t{}\n".format(date, content))

    file = open("output.txt","w")
    for tweet in tweetlist:
        file.write(tweet)
    file.close()

if __name__ == '__main__':
    searchTwitter(sys.argv[1])
