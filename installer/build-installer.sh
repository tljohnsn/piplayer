#!/bin/bash
git clone https://github.com/blu-base/unattended-debian-installer/
cd unattended-debian-installer/profiles/
rm custom.p*
ln -s ~/piplayer/installer/custom.packages .
ln -s ~/piplayer/installer/custom.preseed .
ln -s ~/piplayer/installer/custom.postinst .

