#!/bin/bash
#nmcli --ask device wifi connect "Island WiFi 24324"
python3 -m venv ~/.local
~/.local/bin/pip3 install imgcat
sudo apt-get install gnuplot

mkdir oldpython
cd oldpython
wget http://ftp.debian.org/debian/pool/main/libf/libffi/libffi7_3.3-6_armhf.deb
wget http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_armhf.deb
wget http://ftp.debian.org/debian/pool/main/p/python2.7/libpython2.7-minimal_2.7.18-8+deb11u1_armhf.deb
wget http://ftp.debian.org/debian/pool/main/p/python2.7/python2.7-minimal_2.7.18-8+deb11u1_armhf.deb
wget http://ftp.debian.org/debian/pool/main/p/python2.7/libpython2.7-stdlib_2.7.18-8+deb11u1_armhf.deb
wget http://ftp.debian.org/debian/pool/main/p/python2.7/python2.7_2.7.18-8+deb11u1_armhf.deb

sudo dpkg -i libffi7_3.3-6_armhf.deb libssl1.1_1.1.1w-0+deb11u1_armhf.deb libpython2.7-minimal_2.7.18-8+deb11u1_armhf.deb python2.7-minimal_2.7.18-8+deb11u1_armhf.deb libpython2.7-stdlib_2.7.18-8+deb11u1_armhf.deb python2.7_2.7.18-8+deb11u1_armhf.deb
