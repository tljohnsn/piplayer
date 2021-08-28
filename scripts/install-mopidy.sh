#!/bin/bash
wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list

sudo apt update

# Install mopidy
# https://docs.mopidy.com/en/latest/installation/debian/#debian-install
sudo apt -y install mopidy
sudo apt -y install mopidy-mpd mopidy-local

# Added for pi https://docs.mopidy.com/en/latest/installation/raspberrypi/
sudo usermod -a -G video mopidy

#Iris https://mopidy.com/ext/iris/
sudo python3 -m pip install Mopidy-Iris Mopidy-PlaybackDefaults
sudo install -b -o root -g root -m 644 ~pi/piplayer/configfiles/mopidy.conf /etc/mopidy

#sudo install -b -o root -g root -m 755 ~pi/piplayer/scripts/mopidylocalscan /etc/cron.daily/
sudo systemctl enable --now mopidy.service

sudo install -b -o root -g root -m 440 ~pi/piplayer/configfiles/mopidyscan /etc/sudoers.d/mopidyscan
