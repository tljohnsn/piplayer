#!/bin/bash
git clone https://github.com/blu-base/unattended-debian-installer/
cd unattended-debian-installer/profiles/
rm custom.p*
ln -s ~/piplayer/installer/custom.packages .
ln -s ~/piplayer/installer/custom.preseed .
ln -s ~/piplayer/installer/custom.postinst .


sudo xorriso -osirrox on -indev debian-12-i386-CD-1.iso  -extract / isofiles/
sudo chmod u+w ./simple-cdd/custom.postinst
cd isofiles/simple-cdd/
sudo tar -xzf extras.tar.gz
#do stuff in extras dir
#cp ~/piplayer/installer/custom.postinst .
cd ..
sudo tar -czf extras.tar.gz extras
sudo rm -rf extras
cd ..
sudo chmod u-w ./simple-cdd/custom.postinst
sudo chmod a+w md5sum.txt
sudo md5sum `gfind -follow -type f` > md5sum.txt
sudo chmod a-w md5sum.txt

