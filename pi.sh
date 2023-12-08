#!/bin/bash
#Setup variables
host_name=raspberrypi
wan_interface=eth0
join_wifi_network=Jupiter
join_wifi_password=secret
create_wifi_network=raspberrypi
create_wifi_password=secret
wifi_mode=create
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

sudo sed -i -e "s/^# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sudo locale-gen

if [ ! -f ~pi/.ssh/authorized_keys ]; then
mkdir -p ~pi/.ssh
echo "ssh-rsa $sshkey0 newlaptopkey" >>~pi/.ssh/authorized_keys
echo "ssh-rsa $sshkey1 tljohnsn@smack.office.useractive.com" >>~pi/.ssh/authorized_keys
chown pi ~pi/.ssh/authorized_keys
chmod 600 ~pi/.ssh/authorized_keys
fi

if [ ! -f /usr/bin/git ]; then
   exit "run me as root for debian install"
   apt-get -y install sudo wget openssh-server linux-libc-dev git gnupg python3-pip curl avahi-daemon rsync alsa-utils net-tools
   echo "pi ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/010_pi-nopasswd
   chmod 440 /etc/sudoers.d/010_pi-nopasswd
   systemctl enable --now avahi-daemon
   systemctl disable rsync
fi

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global core.editor emacs

sudo apt update
sudo apt -y -m install mpg321 automake libsdl-ttf2.0-dev libsdl-image1.2-dev emacs-nox dos2unix hostapd dnsmasq raspberrypi-kernel-headers \
     apache2 php php-common php-mysql php-curl php-xml composer php-gd ffmpeg \
     php-curl php-sqlite3 php-json php-xml php-mbstring imagemagick \
     inotify-tools expect gridsite-clients alsa-tools sqlite3 ntp
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent samba samba-common-bin 
sudo yum -y install bluealsa

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

#install mpd
sudo apt -y install mpd mpc
# Added for pi https://docs.mopidy.com/en/latest/installation/raspberrypi/
sudo usermod -a -G video mpd

if [ `arch` = "armv7l" ]; then
    sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/mpd.conf.buster /etc/mpd.conf
fi
if [ `arch` = "i686" ]; then
    sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/mpd.conf /etc/mpd.conf
fi		       
sudo install -b -o root -g root -m 755 ~pi/piplayer/scripts/backuprompr /etc/cron.daily/
sudo systemctl enable --now mpd.service

# Setup access point
# https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

if [ "$wifi_mode" = "create" ]; then
    echo '
interface wlanboard
   static ip_address=192.168.5.1/24
   nohook wpa_supplicant
' | sudo tee -a /etc/dhcpcd.conf
echo '
no-hosts
interface=wlanboard
dhcp-range=192.168.5.100,192.168.5.200,255.255.255.0,24h
                # Pool of IP addresses served via DHCP
domain=wlan     # Local wireless DNS domain
address=/gw.wlan/192.168.5.1  # Alias for this router
'| sudo tee /etc/dnsmasq.conf
echo "192.168.5.1 $host_name.local" | sudo tee -a /etc/hosts
fi


echo 'net.ipv4.ip_forward=1' |sudo tee -a /etc/sysctl.d/routed-ap.conf
sudo iptables -t nat -A POSTROUTING -o $wan_interface -j MASQUERADE
sudo netfilter-persistent save
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

#git clone https://github.com/lwfinger/rtl8188eu.git
#cd rtl8188eu
#make
#sudo make install

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
~pi/piplayer/scripts/install-rompr.sh

#Finish
sudo install -b -o www-data -g www-data -m 644 ~pi/piplayer/configfiles/index.php /var/www/html/index.php
sudo install -b -o root -g root -m 755 ~pi/piplayer/configfiles/rc.local /etc
sudo install -b -o root -g root -m 755 ~pi/piplayer/configfiles/smb.service /etc/avahi/services/smb.service
sudo rm /var/www/html/index.html
echo 'date.timezone = "US/Central"' | sudo tee -a /etc/php/7.?/apache2/conf.d/99-timezone.ini
echo 'max_execution_time = 120' | sudo tee -a /etc/php/7.?/apache2/conf.d/99-tunes.ini
sudo timedatectl set-timezone US/Central

if [ "$wifi_mode" = "join" ]; then
    sudo bash ~pi/piplayer/scripts/danielst.sh
fi

if [ "$eth0_mode" = "consort" ]; then
        echo '
interface eth0
   static ip_address=10.0.4.2/24
' | sudo tee -a /etc/dhcpcd.conf
sudo install -b -o root -g root -m 755 ~pi/piplayer/configfiles/dnsmasq.consort.conf /etc/dnsmasq.conf
echo "10.0.4.2 $host_name.local" | sudo tee -a /etc/hosts
sudo ~pi/piplayer/scripts/install-gpsd.sh
sudo apt -y install socat tcpdump
fi

sudo sed -i -e "s/raspberrypi/$host_name/" /etc/hosts /etc/mailname /etc/hostname
sudo sed -i -e "s/rootwait/rootwait ipv6.disable=1/" /boot/cmdline.txt

cat ~/piplayer/configfiles/bashrc.txt >>~pi/.bashrc

if [ "$pi_ssh_password" != "raspberry" ]; then
    echo Changing pi login password
    echo "pi:$pi_ssh_password" | sudo chpasswd
fi
