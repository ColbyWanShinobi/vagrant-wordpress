#!/bin/bash
#This script is responsible for installing and configuring a specific application.

#Stop on errors
set -e
set -x

appName="LAMP"
appHomeDir=""
appUserName=""
appGroupName=""
appPassword=""
DBPASSWDR="password"

SERVERIP=`sh /vagrant/get-ip.sh`

echo "Beginning setup and configuration for $appName..."

echo "Installing system dependencies..."
#echo -e "\n--- Install MySQL specific packages and settings ---\n"
echo "Installing mySQL Server..."
echo "mysql-server mysql-server/root_password password $DBPASSWDR" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWDR" | debconf-set-selections
apt-get install -y mysql-server

apt-get install -y apache2 php8.1-mysql php8.1 libapache2-mod-php8.1

echo "Updating Apache config to recognize index.php, index.phtml..."
a2enmod php8.1
# cat > /etc/apache2/mods-enabled/dir.conf <<DELIM
# <IfModule mod_dir.c>
# 	DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm index.php index.phtml
# </IfModule>
#
# # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
# DELIM

a2enmod rewrite

echo "Creating info.php"
cat > /var/www/html/info.php <<DELIM
<?php
phpinfo();
?>
DELIM
rm -f /etc/apache2/sites-enabled/000-default.conf
cp -s /vagrant/000-default.conf /etc/apache2/sites-enabled/
echo "Restarting Apache..."
service apache2 restart

echo "You may now connect to: http://$SERVERIP"
echo "THIS SERVER IS NOT SECURE!!! FOR LOCAL USE ONLY!!!"
