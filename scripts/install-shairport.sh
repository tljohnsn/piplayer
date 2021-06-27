#!/bin/bash
cd
git clone https://github.com/mikebrady/shairport-sync.git
cd shairport-sync/
sudo apt-get install build-essential git xmltoman autoconf automake libtool libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev
autoreconf -fi
./configure --sysconfdir=/etc --with-alsa --with-soxr --with-avahi --with-ssl=openssl --with-systemd
make
make install
sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/shairport-sync.conf /etc/shairport-sync.conf
sudo systemctl enable shairport-sync
sudo systemctl start shairport-sync
