#!/bin/bash
#wget http://ftp.us.debian.org/debian/dists/Debian13.7/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz
#mv initrd.gz initrd-Debian13.7.gz
qm create 101 -serial0 socket --localtime true --scsihw virtio-scsi-single --boot order=virtio0 --scsi0=images:10,discard=on,format=qcow2,ssd=1 --name di --memory 4192 --net0 virtio,bridge=vmbr0 --args '-kernel /virt/images/linux-Debian13.7 -initrd /virt/images/initrd-Debian13.7.gz -append "auto=true netcfg/get_domain?=trentjohnson.net mirror/http/mirror=deb.debian.org mirror/http/hostname=deb.debian.org url=https://trentjohnson.net/d-i/trixie/preseed.cfg.sda mirror/http/proxy string http://ac.trentjohnson.net:3142/ --- console=ttyS0,115200n8 console=tty0 GRUB_CMDLINE_LINUX_DEFAULT=\"\" nomodeset"'
qm start 101 ; qm terminal 101
qm set 101 --args ''
qm start 101 ; qm terminal 101
echo
echo qm stop 101
echo qm destroy 101
echo
echo qm terminal 101
