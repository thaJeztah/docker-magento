#! /bin/bash

if [[ -e /firstrun ]]; then

	echo "Not first run so skipping initialization"

else 

	echo "setting the default installer info for magento"
	sed -i "s/<host>localhost/<host>${DB_PORT_3306_TCP_ADDR}/g" /var/www/app/etc/config.xml
	sed -i "s/<username\/>/<username>user<\/username>/" /var/www/app/etc/config.xml
	sed -i "s/<password\/>/<password>password<\/password>/g" /var/www/app/etc/config.xml

	echo "show tables" | mysql -u "$DB_ENV_MYSQL_USER" --password="$DB_ENV_MYSQL_PASSWORD" -h $DB_PORT_3306_TCP_ADDR -P "$DB_PORT_3306_TCP_PORT" magento


	echo "Adding Magento Caching"

	sed -i -e  '/<\/config>/{ r /var/www/app/etc/mage-cache.xml' -e 'd}' /var/www/app/etc/local.xml.template

	touch /firstrun

fi

service php-fpm start

nginx 
