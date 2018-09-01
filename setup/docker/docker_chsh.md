To remove all not associated with any container
```
docker image prune -a
```

To remove container
```
docker stop 0fd99ee0cb61
docker rm -f 0fd99ee0cb61
```


default version
```
docker pull mysql:latest
docker run --name leetcode -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123 mysql:latest
```
Dockerfile version
```
docker build -t lz1714/mysql01 .
docker run --name db1 -p 3306:3306 -d lz1714/mysql01
```
access from bash
```
docker exec -it leetcode /bin/bash
mysql -uroot -p123
```
if need to change the root password
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'DFDF3332aaaa';
```

connection url:
jdbc:mysql://localhost:3306/leetcodedb
