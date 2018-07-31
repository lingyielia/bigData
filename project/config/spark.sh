chmod 400 newspark.pem
# ssh -i newspark.pem ubuntu@ec2-54-82-44-45.compute-1.amazonaws.com
ssh -i sparkkey.pem ubuntu@ec2-54-82-44-45.compute-1.amazonaws.com

sudo apt-get update
sudo apt install python3-pip

pip3 install jupyter
sudo apt-get install default-jre
sudo apt-get install scala
pip3 install py4j
wget http://archive.apache.org/dist/spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.7.tgz
sudo tar -zxvf spark-2.1.1-bin-hadoop2.7.tgz

cd spark-2.1.1-bin-hadoop2.7/
pwd
# /home/ubuntu/spark-2.1.1-bin-hadoop2.7

pip3 install findspark

jupyter notebook --generate-config
mkdir certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
cd ~/.jupyter/
vi jupyter_notebook_config.py

# in jupyter config
c = get_config()
c.NotebookApp.certfile = u'/home/ubuntu/certs/mycert.pem'
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
# esc + wq!

jupyter notebook
https://ec2-54-82-44-45.compute-1.amazonaws.com:8888/?token=5675d8a91961eea28d3efa6ec28c05a9aa775e3c9b621488

#EMR
# start a new cluster
# N. Califorlia zone
# add EC2 keypair (chomd 400 westkey.pem)
# add master inbound rule (ssh and port 8890)
ec2-54-153-52-96.us-west-1.compute.amazonaws.com:8890
# in zeppelin
%pyspark
df = spark.read.csv("s3......")
