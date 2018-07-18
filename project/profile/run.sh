hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapreduce.job.reduces=1 -files hdfs://dumbo/user/lz1714/project/profile/type_mapper.py,hdfs://dumbo/user/lz1714/project/profile/type_reducer.py -mapper "python type_mapper.py" -reducer "python type_reducer.py" -input /user/lz1714/project/output_final/part-00000 -output /user/lz1714/project/profile/output1

hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapreduce.job.reduces=1 -files hdfs://dumbo/user/lz1714/project/profile/dow_mapper.py,hdfs://dumbo/user/lz1714/project/profile/type_reducer.py -mapper "python dow_mapper.py" -reducer "python type_reducer.py" -input /user/lz1714/project/output_final/part-00000 -output /user/lz1714/project/profile/output2

hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapreduce.job.reduces=1 -files hdfs://dumbo/user/lz1714/project/profile/hod_mapper.py,hdfs://dumbo/user/lz1714/project/profile/type_reducer.py -mapper "python hod_mapper.py" -reducer "python type_reducer.py" -input /user/lz1714/project/output_final/part-00000 -output /user/lz1714/project/profile/output3

hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapreduce.job.reduces=1 -files hdfs://dumbo/user/lz1714/project/profile/station_mapper.py,hdfs://dumbo/user/lz1714/project/profile/type_reducer.py -mapper "python station_mapper.py" -reducer "python type_reducer.py" -input /user/lz1714/project/output_final/part-00000 -output /user/lz1714/project/profile/output4
