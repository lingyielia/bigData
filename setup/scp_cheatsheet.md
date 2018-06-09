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
```
 
* from HDFS to workstation:
```
hdfs dfs -get /user/lz1714/class3/output ./class3
```

* from workstation to HDFS:
```
hdfs dfs -put ./class3/pageRank_mapper.py /user/lz1714/class3/python_code
```
