#!/bin/bash
rm /etc/nginx/sites-available/default && rm /etc/php/7.3/fpm/pool.d/www.conf && rm /etc/nginx/sites-enabled/default
mv /default /etc/nginx/sites-available/default && mv /www.conf /etc/php/7.3/fpm/pool.d/www.conf
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
echo "<?php phpinfo(); ?>" | tee /var/www/index.php
wget -q https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -zxf phpMyAdmin-4.9.0.1-all-languages.tar.gz && rm phpMyAdmin-4.9.0.1-all-languages.tar.gz
mv phpMyAdmin-4.9.0.1-all-languages /usr/share/phpmyadmin && mv /config.inc.php /usr/share/phpmyadmin/config.sample.inc.php
/etc/init.d/mysql start && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE phpmyadmin" && echo "3" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} phpmyadmin < /usr/share/phpmyadmin/sql/create_tables.sql && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass'" && echo "1" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES" && echo "2" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE wpdatabase" && echo "3" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER 'wpuser' IDENTIFIED BY 'wppass'"  && echo "4" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT USAGE ON wpdatabase.* TO 'wpuser'@localhost IDENTIFIED BY 'wppass'"  && echo "6" && \
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL privileges ON wpdatabase.* TO 'wpuser'@localhost" && echo "7"
            mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES" && echo "8" && \
mkdir /usr/share/phpmyadmin/tmp
chmod 777 /usr/share/phpmyadmin/tmp
chown -R www-data:www-data /usr/share/phpmyadmin
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz && rm latest.tar.gz
mv wp-config.php wordpress/
mv wordpress /var/www/