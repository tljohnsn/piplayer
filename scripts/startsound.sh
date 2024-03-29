#!/bin/bash
source /etc/os-release
sleep 10
su -c "aplay /usr/share/sounds/alsa/Front_Center.wav" - pi | tee -a /var/log/aplay.log &
su -c "aplay -t raw -r 48000 -c 2 -f S16_LE /dev/zero" - pi | tee -a /var/log/aplay.log &
if [ "$VERSION_CODENAME" = "bookworm" ]; then
   su -c "mpd /home/pi/piplayer/configfiles/mpd.bookworm.conf" - pi | tee -a /var/log/aplay.log
fi
amixer sset 'Master' 50%

