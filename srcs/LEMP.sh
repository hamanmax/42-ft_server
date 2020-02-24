#!/bin/bash
echo "\e[91m########## INSTALLATION ET RECUPERATION DES FICHIERS SOURCES ##########"
rm /etc/nginx/sites-available/default && rm /etc/php/7.3/fpm/pool.d/www.conf && rm /etc/nginx/sites-enabled/default
export AUTOINDEX && envsubst '${AUTOINDEX}' < /default > /etc/nginx/sites-available/default && rm default
mv /www.conf /etc/php/7.3/fpm/pool.d/www.conf
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
echo "\e[92mTELECHARGEMENT DE PHPMYADMIN" && wget -q https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz && tar -zxf phpMyAdmin-4.9.0.1-all-languages.tar.gz && rm phpMyAdmin-4.9.0.1-all-languages.tar.gz
echo "\e[92mTELECHARGEMENT DE WORDPRESS" &&wget -q https://wordpress.org/latest.tar.gz && tar -xzf latest.tar.gz && rm latest.tar.gz
mv phpMyAdmin-4.9.0.1-all-languages /usr/share/phpmyadmin && mv /config.inc.php /usr/share/phpmyadmin/config.sample.inc.php && mv wp-config.php wordpress/ && mv wordpress /var/www/
echo "\e[91m########## CREATION DES BASES DE DONNES MYSQL ET GESTION DES UTILISATEURS ##########\e[92m"
/etc/init.d/mysql start && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE phpmyadmin" > /dev/null 2>&1 && echo "\e[92mETAPES 1/9" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} phpmyadmin < /usr/share/phpmyadmin/sql/create_tables.sql > /dev/null 2>&1 && echo "\e[92mETAPES 2/9" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass'" > /dev/null 2>&1 && echo "\e[92mETAPES 3/9" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES" > /dev/null 2>&1 && echo "\e[92mETAPES 4/9"  && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE wpdatabase"> /dev/null 2>&1 && echo "\e[92mETAPES 5/9" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER 'wpuser' IDENTIFIED BY 'wppass'" > /dev/null 2>&1 && echo "\e[92mETAPES 6/9" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT USAGE ON wpdatabase.* TO 'wpuser'@localhost IDENTIFIED BY 'wppass'" > /dev/null 2>&1 && echo "\e[92mETAPES 7/9" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL privileges ON wpdatabase.* TO 'wpuser'@localhost" > /dev/null 2>&1 && echo "\e[92mETAPES 8/9" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES" > /dev/null 2>&1 && echo "\e[92mETAPES 9/9" && \
mkdir /usr/share/phpmyadmin/tmp
chmod 777 /usr/share/phpmyadmin/tmp
chown -R www-data:www-data /usr/share/phpmyadmin
echo "\e[91m########## INSTALLATION DU PROTOCOL SSL/TSL ##########\e[92m"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt  -subj "/C=FR/ST=AURA/L=Lyon/O=42Lyon/CN="
mv self-signed.conf /etc/nginx/snippets/self-signed.conf && mv ssl-params.conf /etc/nginx/snippets/ssl-params.conf
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
echo "\e[91m########## FIN DE L'INSTALLATION DU SCRIPT ##########\e[39m"