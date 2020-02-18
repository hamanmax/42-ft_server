FROM debian:buster
RUN apt-get update -qq -y && apt-get upgrade -qq -y
RUN apt-get install -qq -y nginx mariadb-server php7.3-common php7.3-cli php7.3-fpm php7.3-json php7.3-mysql php7.3-mbstring wget vim
COPY srcs/default srcs/LEMP.sh srcs/www.conf srcs/config.inc.php srcs/wp-config.php ./
RUN sh LEMP.sh
ENTRYPOINT service mysql start && service php7.3-fpm start && nginx -g'daemon off;'
EXPOSE 80