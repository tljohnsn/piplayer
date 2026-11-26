#!/bin/bash
export COMMONOPS="--localtime true --scsihw virtio-scsi-single --agent enabled=1,fstrim_cloned_disks=1,type=virtio --onboot --boot order=scsi0"
export NETDEV="vmbr0"
if [[ -z $STORAGE ]]; then
   export STORAGE="tank-nc"
fi
if [[ -z $VMID ]]; then
    export VMID=106
fi

if [ ! -f /virt/images/linux-Debian13.7 ]; then
    wget -O /virt/images/linux-Debian13.7 http://ftp.us.debian.org/debian/dists/Debian13.7/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux
    wget http://ftp.us.debian.org/debian/dists/Debian13.7/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz -O /virt/images/initrd-Debian13.7.gz
fi

#qm create 106 -serial0 socket --localtime true --scsihw virtio-scsi-single --boot order=virtio0 --scsi0=images:10,discard=on,format=qcow2,ssd=1 --name di --memory 4192 --net0 virtio,bridge=vmbr0 --args '-kernel /virt/images/linux-Debian13.7 -initrd /virt/images/initrd-Debian13.7.gz -append "auto=true netcfg/get_domain?=trentjohnson.net mirror/http/mirror=deb.debian.org mirror/http/hostname=deb.debian.org url=https://trentjohnson.net/d-i/trixie/preseed.cfg.sda mirror/http/proxy string http://ac.trentjohnson.net:3142/ --- console=ttyS0,115200n8 console=tty0 GRUB_CMDLINE_LINUX_DEFAULT=\"\" nomodeset"'

qm create $VMID $COMMONOPS $NAME --serial0 socket --scsi0=$STORAGE:10,discard=on,ssd=1 --name di --memory 4192 --net0 virtio$MAC,bridge=$NETDEV --args '-kernel /virt/images/linux-Debian13.7 -initrd /virt/images/initrd-Debian13.7.gz -append "auto=true netcfg/get_domain?=trentjohnson.net mirror/http/mirror=ac.trentjohnson.net url=https://trentjohnson.net --- console=ttyS0,115200n8 console=tty0 consoleblank=0 nomodeset GRUB_CMDLINE_LINUX_DEFAULT=\"\""'

qm start $VMID ; qm terminal $VMID
qm set $VMID --args ''
qm start $VMID ; qm terminal $VMID

echo
echo qm stop $VMID
echo qm destroy $VMID
echo
echo qm terminal $VMID
