#!/bin/bash
#https://d0m.me/2023/10/01/debian-12-bookworm-install-php-7-4/
curl -sSL https://packages.sury.org/php/README.txt | bash -x
apt update
apt remove php php-common php-mysql php-curl php-xml php-gd php-curl php-sqlite3 php-json php-xml php-mbstring
apt install php7.4 php7.4-common php7.4-mysql php7.4-mysql php7.4-curl php7.4-xml php7.4-gd php7.4-curl php7.4-sqlite3 php7.4-json php7.4-mbstring 

