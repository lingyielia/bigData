records = LOAD 'class5/tweet.txt' as line;
pureChar = FOREACH records GENERATE REPLACE(line, '([^a-zA-Z\\s]+)',' ') AS pureStr;

/*
Convert all special characters into space for further tokenizing.
https://stackoverflow.com/questions/25939194/unable-to-remove-special-characters-in-pig
*/

tokens = FOREACH pureChar GENERATE FLATTEN(TOKENIZE (LOWER (pureStr), ' ')) AS token;
keywords = LOAD 'class5/searchStr.txt' as searchword;

/*
After loading and preparing both tweet text and keywords,
now using left outer join to preserve the occurrence of keywords we care about.
https://www.hdfstutorial.com/blog/pig-join-example-2/
*/

joined = JOIN keywords BY LOWER(searchword) LEFT OUTER, tokens BY token;
occur = FOREACH joined GENERATE keywords::searchword AS keys, (tokens::token is null? 0:1) AS values;
grouped = GROUP occur BY keys;
result = FOREACH grouped GENERATE group AS inputTerm, SUM(occur.values) AS tweetCount;

STORE result INTO '/user/lz1714/class5/output';
