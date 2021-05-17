#!/bin/bash
sudo apt -y install mariadb-server mariadb-client

sudo systemctl stop mariadb.service
sudo rm -rf /var/lib/mysql
sudo mkdir /var/lib/mysql
sudo chown mysql.mysql /var/lib/mysql
sudo mysql_install_db
sudo systemctl enable --now mariadb.service


#echo "CREATE DATABASE ampache" | mysql -sfu root
#echo "CREATE USER 'ampache'@'localhost' IDENTIFIED BY 'ampache_password'" | mysql -sfu root
#echo "GRANT ALL PRIVILEGES ON ampache.* TO 'ampache'@'localhost';" | mysql -sfu root
mysql -sfu root < ~pi/piplayer/scripts/mysql_secure_installation.sql

cd
wget https://github.com/ampache/ampache/archive/master.tar.gz
tar -xzf master.tar.gz
mkdir -p ampache-master/config
sudo mv ampache-master/ /var/www/html/ampache/
cd /var/www/html/ampache
composer install --prefer-source --no-interaction
sudo chown -R www-data:www-data /var/www/html/ampache

#MySQL Administrative Username: ampache
#MySQL Administrative Password: ampache_password
#Create Database: unchecked
#Transcoding Template Configuration: ffmpeg

sudo mkdir -m 777 /var/log/ampache
sudo -u www-data php /var/www/html/ampache/bin/install/install_db.inc -U root -P root -u ampache -p $db_ampache_password -d ampache -h 127.0.0.1 -w /ampache -f
sudo mv /var/www/html/ampache/config/ampache.cfg.php /var/www/html/ampache/config/ampache.cfg.php.dist
sudo install -b -o www-data -g www-data -m 644 ~pi/piplayer/configfiles/ampache.cfg.php /var/www/html/ampache/config/
sudo sed -i -e "s/ampache_password/$db_ampache_password/" \
     -e "s/ampache_key/$ampache_key/" \
     -e "s/1135194687c7ddd6c4f02ceac94a58f9/$spotify_client_id/" \
     -e "s/104eb248d68e6467c3b8087dc0c687cd/$spotify_client_secret/" \
     /var/www/html/ampache/config/ampache.cfg.php

echo "INSERT INTO catalog VALUES (1,'mp3zpi','local',0,NULL,1601051240,1,'%T - %t','%a - %A','music')" | mysql -u root -proot ampache
echo "INSERT INTO catalog_local VALUES (1,'/home/ftp/local/mp3zpi',1)" | mysql -u root -proot ampache
echo "INSERT INTO localplay_mpd VALUES (1,'mpd',-1,'127.0.0.1',6600,'',0)" | mysql -u root -proot ampache

echo "INSERT INTO catalog VALUES (2,'convertedflacspi','local',0,NULL,1601051240,1,'%T - %t','%a - %A','music')" | mysql -u root -proot ampache
echo "INSERT INTO catalog_local VALUES (2,'/home/ftp/local/convertedflacspi',2)" | mysql -u root -proot ampache

echo "update artist SET summary='Blank'" | mysql -u root -proot ampache
echo "UPDATE mysql.user SET Password=PASSWORD('$db_root_password') WHERE User='root';" | mysql -u root -proot
echo "FLUSH PRIVILEGES" |mysql -u root -proot

sudo -u www-data php /var/www/html/ampache/bin/catalog_update.inc
