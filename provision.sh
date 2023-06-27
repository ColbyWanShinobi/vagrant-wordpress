#!/bin/bash
#This script is responsible for provisioning the server.
#All application specific setup should be done in another file.
#The goal is to be able to deploy each app individually on the server by having
# the app specific script being self contained.

set -e

echo "This script will provision the server. It will get the server ready for application installation."

echo "Updating the repositories..."
apt-get update -y

echo "Upgrading the base packages..."
apt-get upgrade -y

#If you're using a cloud provider or vagrant, ssh will already be installed most likely.
#If you are trying to use this script on any other install, make sure that the ssh server is installed
#apt-get install openssh-server -y

echo "Installing system utilities..."
apt-get install htop -y

#Set Timezone
newTimeZone="America/New_York"
echo "Getting current timezone..."
cat /etc/timezone
echo "Setting current timezone..."
echo $newTimeZone > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

#Base server configuration has been completed. Now you can execute any application specific provisioning scripts
sh /vagrant/provision-lamp.sh
sh /vagrant/provision-wordpress.sh

#!!!!!!!!!!!!!If this is a cloud box, we need to disable root login via ssh!!!!!!!!!!!!!!!!!!
echo "You may now connect to: http://$SERVERIP"
echo "THIS SERVER IS NOT SECURE!!! FOR LOCAL USE ONLY!!!"
