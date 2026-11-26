#!/bin/bash
export VMID="216"
export MAC="=54:52:0a:00:02:d8"
export NAME="--name sonar2"
export STORAGE="tank-z"

./debian.sh
exit

apt -y install qbittorrent-nox
curl -o install-sonarr.sh https://raw.githubusercontent.com/Sonarr/Sonarr/develop/distribution/debian/install.sh

sudo bash ./install-sonarr.sh
run as trentj:trentj

add indexer
get key from:
https://broadcasthe.net/user.php?action=edit&userid=1530085#section5.editprofile

add profile Gameshow
Check Web 720p, HDTV-720p, Web 480p, SDTV

Under media manegement check "Unmonitor Deleted Episodes"

Under download client uncheck "Remove completed"
