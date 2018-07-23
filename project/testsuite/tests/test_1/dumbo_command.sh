# dumbo
mkdir project/testsuite/test_1/flow
mkdir project/testsuite/test_1/incid

# local
scp flow_sample.txt dumbo:project/testsuite/test_1/flow
scp incid_sample.txt dumbo:project/testsuite/test_1/incid

# dumbo
hdfs dfs -mkdir /user/lz1714/project/hiveInput/flow
hdfs dfs -mkdir /user/lz1714/project/hiveInput/incid
hdfs dfs -put project/testsuite/test_1/flow/flow_sample.txt /user/lz1714/project/hiveInput/flow
hdfs dfs -put project/testsuite/test_1/incid/incid_sample.txt /user/lz1714/project/hiveInput/incid

hdfs dfs -setfacl -m default:user:impala:rwx /user/lz1714
hdfs dfs -setfacl -m user:impala:rwx /user/lz1714
hdfs dfs -setfacl -R -m user:impala:rwx /user/lz1714/project/hiveInput

beeline

# get temp table file created in hive
hdfs dfs -get hdfs://dumbo/user/hive/warehouse/test__1.db/incident_count_new ./project
