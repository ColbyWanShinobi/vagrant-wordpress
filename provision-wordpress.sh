#!/bin/bash
#This script is responsible for installing and configuring a specific application.

#Stop on errors
set -e
set -x

appName="Wordpress"
appHomeDir="/opt/wordpress"
appUserName="wordpress"
appGroupName="wordpress"
appPassword="wordpress"
DBPASSWDR="password"
DBUSER="wordpress"
DBPASSWD="password"
DBNAME="wordpress"
OSUSER="vagrant"

SERVERIP=`sh /vagrant/get-ip.sh`

echo "Beginning setup and configuration for $appName..."

#sudo apt-get install -y php5-gd libssh2-php
sudo apt-get install -y php8.1-ssh2 php-ssh2-all-dev php-ssh2

mysql -u root -p$DBPASSWDR -e "CREATE DATABASE $DBNAME;"
mysql -u root -p$DBPASSWDR -e "CREATE USER $DBUSER@localhost;"
mysql -u root -p$DBPASSWDR -e "ALTER USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASSWD';"
mysql -u root -p$DBPASSWDR -e "GRANT ALL ON wordpress.* TO '$DBUSER'@'localhost';"
mysql -u root -p$DBPASSWDR -e "FLUSH PRIVILEGES;"

if [ ! -f /vagrant/html/wp-config.php ]; then
  mkdir -p /vagrant/html
  cd /vagrant/html
  echo "Downloading the latest Wordpress package..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp
  wp core download --allow-root
  wp core config --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASSWD --allow-root
  # wp core install --allow-root
  # wget http://wordpress.org/latest.tar.gz
  # tar -xzvf latest.tar.gz
  #
  # cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

  sed -i 's/database_name_here/'$DBNAME'/' /vagrant/html/wp-config.php
  sed -i 's/username_here/'$DBUSER'/' /vagrant/html/wp-config.php
  sed -i 's/password_here/'$DBPASSWD'/' /vagrant/html/wp-config.php
fi

rm -rf /var/www/html
ln -s /vagrant/html /var/www

chown -Rv nobody:www-data /var/www/html
chmod -Rv g+w /var/www/html
# mv /var/www/html/index.html /var/www/html/index.html.old

echo "Restarting Apache..."
service apache2 restart

echo "You may now connect to: http://$SERVERIP/info.php"
