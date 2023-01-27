#!/bin/bash
apt -y install gpsd gpsd-clients

systemctl stop gpsd.socket
systemctl stop gpsd.service

systemctl disable gpsd.socket
systemctl disable gpsd.service

#test with
#gpsd /dev/ttyACM0 -G -n -N

