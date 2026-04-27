#!/bin/bash
apt install xorriso simple-cdd build-essential
git clone https://github.com/blu-base/unattended-debian-installer/
cd unattended-debian-installer/profiles/
rm custom.p*
ln -s ~/piplayer/installer/custom.packages .
ln -s ~/piplayer/installer/custom.preseed .
ln -s ~/piplayer/installer/custom.postinst .
cd ..
sed -i -e s/ftp.de.debian.org/ftp.us.debian.org/ custom.conf
tar -pczf extras.tar.gz extras/
build-simple-cdd --conf custom.conf --auto-profiles custom --locale en_US --keyboard us --force-root --force-preseed --no-do-mirror --dvd --logfile ./out.log

proxmox-auto-install-assistant prepare-iso proxmox-ve_9.1-1.iso --fetch-from iso --answer-file piplayer/installer/answer.toml \
			       --on-first-boot piplayer/installer/firstboot.sh
dd if=proxmox-ve_9.1-1-auto-from-iso.iso of=/dev/sda bs=4M status=progress
pvecm expected 1
pvecm delnode pve2



sudo xorriso -osirrox on -indev debian-12-i386-CD-1.iso  -extract / isofiles/
sudo chmod u+w isofiles/simple-cdd/custom.postinst
sudo cp ~/piplayer/installer/custom.postinst isofiles/simple-cdd/custom.postinst
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
cd ..
sudo genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o debian-12-unattended.iso isofiles

rsync -avP -e "nssh -p 2222" pi@localhost:debian-12-unattended.iso .
nssh -p 2222 pi@localhost
nssh -p 2223 pi@localhost
