FROM mysql:latest
ENV MYSQL_ROOT_PASSWORD <>
ENV MYSQL_DATABASE leetcodedb
ENV MYSQL_USER <>
ENV MYSQL_PASSWORD <>
ADD script.sql /docker-entrypoint-initdb.d
EXPOSE 3306
