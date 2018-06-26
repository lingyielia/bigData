vi wordCount_mapper.py
vi wordCount_reducer.py
vi tweet.txt

hdfs dfs -ls /
hdfs dfs -ls /user
hdfs dfs -ls /user/lz1714
hdfs dfs -mkdir /user/lz1714/class2
hdfs dfs -put tweet.txt /user/lz1714/class2
hdfs dfs -cat /user/lz1714/class2/tweet.txt

cat ./tweet.txt | ./wordCount_mapper.py | sort | ./wordCount_reducer.py

hdfs dfs -mkdir /user/lz1714/class2/python_code
hdfs dfs -put wordCount_mapper.py class2/python_code
hdfs dfs -put wordCount_reducer.py class2/python_code
hdfs dfs -chmod a+x class2/python_code/wordCount_mapper.py
hdfs dfs -chmod a+x class2/python_code/wordCount_reducer.py

hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapreduce.job.reduces=1 \
-files hdfs://dumbo/user/lz1714/class2/python_code/wordCount_mapper.py,hdfs://dumbo/user/lz1714/class2/python_code/wordCount_reducer.py \
-mapper "python wordCount_mapper.py" \
-reducer "python wordCount_reducer.py" \
-input /user/lz1714/class2/tweet.txt \
-output /user/lz1714/class2/output

hdfs dfs -ls /user/lz1714/class2/output
hdfs dfs -cat /user/lz1714/class2/output/part-00000

hdfs dfs -rm -r /user/lz1714/class2/output
