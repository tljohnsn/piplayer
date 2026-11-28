#!/bin/bash
export VMID="216"
export MAC="=54:52:0a:00:02:d8"
export NAME="--name sonar2"
export STORAGE="tank-z"

./debian.sh
exit

apt -y install qbittorrent-nox cifs-utils

echo "//10.0.2.151/Movies /safemount/shows cifs credentials=/etc/smbcredentials,uid=9806,gid=9806,iocharset=utf8,_netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=0 3 3" \
    | sudo tee -a /etc/fstab
echo "username=tljohnsn
password=" | sudo tee /etc/smbcredentials
chmod 600 /etc/smbcredentials
mkdir -p /safemount/shows
systemctl daemon-reload
sudo systemctl restart remote-fs.target
mount -a
systemctl status safemount-shows.mount

echo "nohup sudo su -c qbittorrent-nox -  trentj </dev/null >/dev/null 2>/dev/null &" | sudo tee -a /etc/rc.local
cp /root/piplayer/configfiles/qBittorrent.conf /users/trentj/.config/qBittorrent/qBittorrent.conf

curl -o install-sonarr.sh https://raw.githubusercontent.com/Sonarr/Sonarr/develop/distribution/debian/install.sh

sudo bash ./install-sonarr.sh
run as trentj:trentj


Under media manegement:
   check "Unmonitor Deleted Episodes"
   add root folder /safemount/shows/Shows

add profile Gameshow
Check Web 720p, HDTV-720p, Web 480p, SDTV

Under indexers:
  add Btn
  get key from:
  https://broadcasthe.net/user.php?action=edit&userid=1530085#section5.editprofile
  set retention to 4

Under download clients:
   add qBitorrent   
   uncheck "Remove completed"

Under General:
   Uncheck "Send Anonymous Usage Data"

Under UI:
   Set short date format "2014-03-25"
   Uncheck "show relative dates"

Under Series:
   Import existing
   Set Quality to Gameshow
   Set Type to daily/date
   Uncheck "Use Season folder"




