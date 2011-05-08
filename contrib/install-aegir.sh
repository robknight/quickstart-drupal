#!/bin/bash

# ################################################################################ Hudson

# README:
#
# This script will install Aegir (a hosting management platform) on aegir.dev
#
HELP="

Aegir Installation complete.

Aegir is a hosting management platform.  Aegir is running at http://aegir.dev

To restart Aegir:  sudo /etc/init.d/apache2 restart

To admin Aegir: http://aegir.dev/

For details on using Aegir, see here: http://aegirproject.org/

NOTE: ABOVE IS A PASSWORD RESET URL.  USE IT TO LOGIN INITIALLY.

NOTE 2: If you lost your password reset url, get a new one for user 'admin' and 
        check the ~/websites/log/mail folder for a password reset email.

********************** TO FINISH, run these commands: **********************
drush dl --destination=/var/aegir/.drush provision-6.x
drush hostmaster-install
exit
# reboot 
********************** TO FINISH, run these commands: **********************
"

MYSQL_USER=root
MYSQL_PASS=quickstart
AEGIR_LOCAL_DOMAIN=aegir.dev
AEGIR_GIT_URL="http://git.aegirproject.org/?p=provision.git;a=blob_plain;f=install.sh.txt;hb=provision-0.4-beta1"

# FROM: http://community.aegirproject.org/node/389

# 2. Install system requirements
zenity --info --text="For local-only development choose:

'Local only' the first Postfix config screen
default on the second config screen"

sudo apt-get -y install apache2 php5 php5-cli php5-gd php5-mysql postfix sudo rsync git-core unzip

# 3.1.1. Apache configuration
sudo a2enmod rewrite
sudo ln -s /var/aegir/config/apache.conf /etc/apache2/conf.d/aegir.conf

# 3.2. DNS configuration
# this is already setup

# 3.3. PHP configuration
## This is set in quickstart-3-lamp.sh
sudo sed -i 's/memory_limit = 64M/memory_limit = 192M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini

# 3.4. Database configuration
sudo apt-get install mysql-server
sudo sed -i 's/bind-address		= 127.0.0.1/#ind-address		= 127.0.0.1/g'            /etc/mysql/my.cnf
sudo /etc/init.d/mysql restart

# 3.5. Create the Aegir user
sudo adduser --system --group --home /var/aegir aegir
sudo adduser aegir www-data    #make aegir a user of group www-data

# 3.6. Sudo configuration
echo "aegir ALL=NOPASSWD: /usr/sbin/apache2ctl" | sudo tee -a /etc/sudoers > /dev/null

# 5. Install Aegir components

echo $HELP

# 4. Stop! Now become the Aegir user!
zenity --info --text="This is for the 'aegir' user.  Password is 'aegir'"
su -s /bin/bash aegir




















exit

#OLD
# ###################################################### BEGIN INSTALL.txt instructions
# This is taken from http://git.aegirproject.org/?p=provision.git;a=blob;f=docs/INSTALL.txt;h=7fd286f74fa719c6d6551081dc106cecd517a903;hb=299e9b83fdc653b1152e5394799bf99a5ff238c3
# some of these steps are already covered in quickstart's install.sh, but we can still run them here...

cd ~
sudo apt-get update

## DNS
echo "127.0.0.1 $AEGIR_LOCAL_DOMAIN" | sudo tee -a /etc/hosts > /dev/null

## Software (Postfix)
# Set install defaults for Postfix
echo postfix       postfix/main_mailer_type   text     Local only                             | sudo debconf-set-selections
echo postfix       postfix/mailname           text     postfix_default@$AEGIR_LOCAL_DOMAIN    | sudo debconf-set-selections

# install software:
sudo apt-get install -y apache2 php5 php5-cli php5-mysql mysql-server postfix
sudo apt-get install -y sudo rsync git unzip

# make aegir user
sudo adduser --system --group --home /var/aegir aegir
sudo adduser aegir www-data      # make aegir a user of group www-data
sudo adduser aegir ssl-cert      # allow aegir to see certs (when restarting apache)

## PHP - this is set in quickstart-3-lamp.sh, and won't work if changed manually.
sudo sed -i 's/memory_limit = 64M/memory_limit = 192M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini

## Apache
sudo a2enmod rewrite
sudo ln -s /var/aegir/config/apache.conf /etc/apache2/conf.d/aegir.conf
# allow aegir to restart apache - (redundant: aegir is already in group apache_tools)
echo 'aegir ALL=NOPASSWD: /usr/sbin/apache2ctl' | sudo tee -a /etc/sudoers > /dev/null

## MySQL
# no config

## Run Install Script
wget -O install.sh.txt "$AEGIR_GIT_URL"
sudo su -s /bin/sh aegir -c "sh install.sh.txt $AEGIR_LOCAL_DOMAIN"

echo "$HELP"
