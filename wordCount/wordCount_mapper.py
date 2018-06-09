#!/usr/bin/env python
import sys
import re
import string

for line in sys.stdin:
    fline = re.sub('['+string.punctuation+']', ' ', line)
    tokenized_tweet = fline.split()
    tokenized_tweet = [word.lower() for word in tokenized_tweet]

    for term in ['hackathon','dec','chicago','Java']:
        if term in tokenized_tweet:
            print("{0}\t{1}".format(term,1))
        else:
            print("{0}\t{1}".format(term,0))
