#Create the tunnel
```      
ssh hpcgwtunnel
```

#Log into dumbo
open a new terminal
```
ssh -Y dumbo
```

#Transfer files
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
