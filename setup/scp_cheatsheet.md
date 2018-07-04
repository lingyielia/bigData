# Create the tunnel
```      
ssh hpcgwtunnel
```

# Log into dumbo
open a new terminal
```
ssh -Y dumbo
```

# Transfer files
open a new terminal, go to the right local directory

* from local to dumbo:

```
scp script.py dumbo:class3/
scp mapper.py reducer.py dumbo:class3/
scp *.py dumbo:class3/
```

* from dumbo to local:

```
scp dumbo:class3/tweet.txt .
scp dumbo:class3/mapper.py dumbo:class3/reducer.py .
scp dumbo:class3/\*.py .
scp -r dumbo:class3/ .
```
* from HDFS to workstation:
```
hdfs dfs -get /user/lz1714/class3/output ./class3
```

* from workstation to HDFS:
```
hdfs dfs -put ./class3/pageRank_mapper.py /user/lz1714/class3/python_code
```


# Pig
Run grunt locally:
```
pig -x local
```

Running scripts (and Jar files) that are stored in HDFS:
```
pig hdfs://dumbo/user/lz1714/class5/searchKeyword.pig
```

exit grunt:
```
quit
```

# Hive
```
hdfs dfs -setfacl -m default:user:impala:rwx /user/lz1714
hdfs dfs -setfacl -m user:impala:rwx /user/lz1714

hdfs dfs -mkdir hiveInput

// Get data ready for Hive tests
$ hdfs dfs -put smallWeather1.txt hiveInput
$ hdfs dfs -ls hiveInput
$ hdfs dfs -cat hiveInput/smallWeather1.txt
$ hdfs dfs -setfacl -R -m user:impala:rwx /user/<your_netID>/hiveInput
```

* Create a hive external table
```
$ beeline
beeline> !connect jdbc:hive2://babar.es.its.nyu.edu:10000/

hive> create database lz1714; 
hive> use lz1714;
hive> show tables;
hive> create external table w1 (data1 string, year int, data2 string, temperature int, quality tinyint, data3 string)
row format delimited fields terminated by ','
location '/user/lz1714/hiveInput/';
hive> show tables; 
hive> describe w1;
```
