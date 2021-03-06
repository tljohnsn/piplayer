#!/bin/bash
#Setup variables
host_name=raspberrypi
wan_interface=eth0
join_wifi_network=Jupiter
join_wifi_password=secret
create_wifi_network=raspberrypi
create_wifi_password=secret
db_ampache_password=ampache_password
db_root_password=root
pi_ssh_password=raspberry
spotify_client_id=1135194687c7ddd6c4f02ceac94a58f9
spotify_client_secret=104eb248d68e6467c3b8087dc0c687cd
ampache_key=fb76b35ab9df5b171af92d75d5e3a714d42c8a1b70d01504bb7a0f8548efcc
sshkey0=AAAAB3NzaC1yc2EAAAADAQABAAAAgQDMEFJLHUXdVfnJ71zabt7P2YSHVe8fE/ueFUH9Rc2uUsJqiBK9l8g/0yfzqoFexdVjgOH3/B4/xvpShJTar0+/FaGOSWPq6KA36KxfBFurLPeA7ngD0j2D/yCx8dXJIziyveFf9bNJYYT0vQBU0pIlsGjfaRhFye2CKzCA0T2jQQ==
sshkey1=AAAAB3NzaC1yc2EAAAADAQABAAAAgQDMEFJLHUXdVfnJ71zabt7P2YSHVe8fE/ueFUH9Rc2uUsJqiBK9l8g/0yfzqoFexdVjgOH3/B4/xvpShJTar0+/FaGOSWPq6KA36KxfBFurLPeA7ngD0j2D/yCx8dXJIziyveFf9bNJYYT0vQBU0pIlsGjfaRhFye2CKzCA0T2jQQ==

if [ -f /boot/tunes.txt ]; then
    source /boot/tunes.txt
fi

if [ ! -f ~pi/.ssh/authorized_keys ]; then
mkdir -p ~pi/.ssh
echo "ssh-rsa $sshkey0 newlaptopkey" >>~pi/.ssh/authorized_keys
echo "ssh-rsa $sshkey1 tljohnsn@smack.office.useractive.com" >>~pi/.ssh/authorized_keys
chown pi ~pi/.ssh/authorized_keys
chmod 600 ~pi/.ssh/authorized_keys
fi

if [ ! -f /usr/bin/git ]; then
   exit "run me as root for debian install"
   echo "pi ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/010_pi-nopasswd
   chmod 440 /etc/sudoers.d/010_pi-nopasswd
   apt-get -y install sudo wget openssh-server linux-libc-dev git gnupg python3-pip curl avahi-daemon rsync alsa-utils net-tools
   systemctl enable --now avahi-daemon
   systemctl disable rsync
fi

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global core.editor emacs

wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
sudo apt update
sudo apt -y install mpg321 automake libsdl-ttf2.0-dev libsdl-image1.2-dev emacs-nox dos2unix hostapd dnsmasq raspberrypi-kernel-headers \
     apache2 php php-common php-mysql php-curl php-xml composer php-gd ffmpeg \
     php-curl php-sqlite3 php-json php-xml php-mbstring imagemagick \
     inotify-tools expect gridsite-clients
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent samba samba-common-bin 

#systemctl enable ssh
#systemctl start ssh

#Install and configure Samba to open a share at /home/ftp/local
sudo mkdir -p -m 777 /home/ftp/local/{mp3zpi,convertedflacspi,playlists}
sudo chown -R pi.pi /home/ftp/local

if [ `grep -c ftp/local /etc/samba/smb.conf` -lt 1 ]; then
sudo sed -i -e "s/\[global\]/\[global\]\nguest account = pi/" /etc/samba/smb.conf
echo '
[public]
   path = /home/ftp/local
   public = yes
   only guest = yes
   writable = yes
   printable = no
   veto files = /._*/.DS_Store/.sync/
   delete veto files = yes
' | sudo tee -a /etc/samba/smb.conf
sudo systemctl enable smbd
sudo systemctl restart smbd
fi
sudo install -b -o root -g root -m 755 ~pi/piplayer/scripts/cleanftp /etc/cron.daily/

# Install mopidy
# https://docs.mopidy.com/en/latest/installation/debian/#debian-install
sudo apt -y install mopidy
sudo apt -y install mopidy-mpd mopidy-local

# Added for pi https://docs.mopidy.com/en/latest/installation/raspberrypi/
sudo usermod -a -G video mopidy

#Iris https://mopidy.com/ext/iris/
sudo python3 -m pip install Mopidy-Iris Mopidy-PlaybackDefaults
sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/mopidy.conf /etc/mopidy
sudo install -b -o root -g root -m 755 ~pi/piplayer/scripts/mopidylocalscan /etc/cron.daily/
#sudo install -b -o root -g root -m 755 ~pi/piplayer/scripts/backuprompr /etc/cron.daily/
sudo systemctl enable --now mopidy.service

# Setup access point
# https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

echo '
interface wlanboard
   static ip_address=192.168.5.1/24
   nohook wpa_supplicant
' | sudo tee -a /etc/dhcpcd.conf

echo 'net.ipv4.ip_forward=1' |sudo tee -a /etc/sysctl.d/routed-ap.conf
sudo iptables -t nat -A POSTROUTING -o $wan_interface -j MASQUERADE
sudo netfilter-persistent save
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

echo '
no-hosts
interface=wlanboard
dhcp-range=192.168.5.100,192.168.5.200,255.255.255.0,24h
                # Pool of IP addresses served via DHCP
domain=wlan     # Local wireless DNS domain
address=/gw.wlan/192.168.5.1  # Alias for this router
'| sudo tee /etc/dnsmasq.conf

echo "192.168.5.1 $host_name.local" | sudo tee -a /etc/hosts

git clone https://github.com/lwfinger/rtl8188eu.git
cd rtl8188eu
make
sudo make install

sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/72-wlan-pi3bplus.rules /etc/udev/rules.d/
sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/wlan.conf /etc/modprobe.d/wlan.conf
sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/hostapd.conf /etc/hostapd/hostapd.conf
sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/wpa_supplicant-wlan2.conf /etc/wpa_supplicant/wpa_supplicant-wlan2.conf

sudo sed -i -e "s/join_wifi_network/$join_wifi_network/" \
     -e "s/join_wifi_password/$join_wifi_password/" \
     -e "s/create_wifi_network/$create_wifi_network/" \
     -e "s/create_wifi_password/$create_wifi_password/" \
     /etc/hostapd/hostapd.conf /etc/wpa_supplicant/wpa_supplicant-wlan2.conf


# Configure sound to always route through bluetooth
if [ -n $bt_addr ]; then
    sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/asound.conf /etc
fi

#https://nxnjz.net/2019/01/installation-of-ampache-on-debian-9/
sudo a2enmod rewrite
sudo a2enmod expires

sudo a2enmod headers
sudo a2enmod deflate

sudo systemctl enable --now apache2.service

#Install rompr
#https://fatg3erman.github.io/RompR/Installation-on-Linux-Alternative-Method.html

cd
wget https://github.com/fatg3erman/RompR/releases/download/1.48/rompr-1.48.zip
unzip -q rompr-1.48.zip
mkdir rompr/{prefs,albumart}
mkdir -p rompr/prefs/databackups
#This patch reduced accidental clicks when trying to re-order the playlist
patch rompr/ui/playlist.js piplayer/configfiles/playlist.diff
ln -s /home/ftp/local rompr/prefs/MusicFolders
cp -a ~pi/piplayer/backups/* rompr/prefs/databackups/.
sudo mv rompr /var/www/html
sudo chown -R www-data.www-data /var/www/html/rompr
curl -b "skin=desktop;currenthost=Default;player_backend=mopidy" -d '[{"action": "metabackup"}]' -H "Content-Type: application/json" -X POST  http://localhost/rompr/ >/dev/null
sudo install -b -o www-data -g www-data -m 644 ~pi/piplayer/configfiles/prefs.var /var/www/html/rompr/prefs/prefs.var

#Finish
sudo install -b -o www-data -g www-data -m 644 ~pi/piplayer/configfiles/index.php /var/www/html/index.php
sudo install -b -o root -g root -m 755 ~pi/piplayer/configfiles/rc.local /etc
sudo install -b -o root -g root -m 755 ~pi/piplayer/configfiles/smb.service /etc/avahi/services/smb.service
sudo rm /var/www/html/index.html
echo 'date.timezone = "US/Central"' | sudo tee -a /etc/php/7.3/apache2/conf.d/99-timezone.ini
sudo timedatectl set-timezone US/Central

sudo sed -i -e "s/raspberrypi/$host_name/" /etc/hosts /etc/mailname /etc/hostname

if [ "$pi_ssh_password" != "raspberry" ]; then
    echo Changing pi login password
    echo pi:pi | sudo chpasswd
fi
