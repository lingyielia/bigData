hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapreduce.job.reduces=1 \
-files hdfs://dumbo/user/lz1714/class3/python_code/pageRank_mapper.py,hdfs://dumbo/user/lz1714/class3/python_code/pageRank_reducer.py \
-mapper "python pageRank_mapper.py" \
-reducer "python pageRank_reducer.py" \
-input /user/lz1714/class3/input.txt \
-output /user/lz1714/class3/output1

hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapreduce.job.reduces=1 \
-files hdfs://dumbo/user/lz1714/class3/python_code/pageRank_mapper.py,hdfs://dumbo/user/lz1714/class3/python_code/pageRank_reducer.py \
-mapper "python pageRank_mapper.py" \
-reducer "python pageRank_reducer.py" \
-input /user/lz1714/class3/output1/part-00000 \
-output /user/lz1714/class3/output2

hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapreduce.job.reduces=1 \
-files hdfs://dumbo/user/lz1714/class3/python_code/pageRank_mapper.py,hdfs://dumbo/user/lz1714/class3/python_code/pageRank_reducer.py \
-mapper "python pageRank_mapper.py" \
-reducer "python pageRank_reducer.py" \
-input /user/lz1714/class3/output2/part-00000 \
-output /user/lz1714/class3/output3
