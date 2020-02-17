FROM debian:buster
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y nginx mariadb-server php7.3-common php7.3-cli php7.3-fpm
RUN /etc/init.d/mysql start && \
        mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE wpdatabase" && echo "1" && \
        mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER 'wpuser' IDENTIFIED BY 'wppassword'"  && echo "2" && \
        mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT USAGE ON *.* TO 'wpuser'@localhost IDENTIFIED BY 'wppassword'"  && echo "3" && \
        mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL privileges ON wpdatabase.* TO 'wpuser'@localhost"
ENTRYPOINT service mysql start && nginx -g'daemon off;'
EXPOSE 80
