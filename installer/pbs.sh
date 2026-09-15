#!/bin/bash
#apt -y install libnss-mdns
echo "set enable-bracketed-paste off" | tee -a /etc/inputrc

nssh tljohnsn@pbs6.local
su - root

echo "KexAlgorithms +diffie-hellman-group1-sha1
PubkeyAcceptedAlgorithms=+ssh-rsa
HostKeyAlgorithms=+ssh-rsa
" | tee -a /etc/ssh/sshd_config

echo "HostKeyAlgorithms=+ssh-rsa
PubkeyAcceptedAlgorithms=+ssh-rsa
" | tee -a /etc/ssh/ssh_config

#apt -y install emacs-nox sudo rsyslog libnss-mdns git pv gpg curl
#apt -y install fupdown2 rdnssd
git clone https://github.com/tljohnsn/piplayer.git /root/piplayer
cat /root/piplayer/configfiles/bashrc.txt >>~root/.bashrc
cat /root/piplayer/configfiles/bashrc.txt >>/etc/skel/.bashrc
cat /root/piplayer/configfiles/bashrc.txt >>/home/tljohnsn/.bashrc

#setup keys
mkdir -p /home/tljohnsn/.ssh
sshkey0=`grep ^sshkey0 /root/piplayer/pi.sh | cut -c 9-`
echo "ssh-rsa $sshkey0 newlaptopkey" >>~tljohnsn/.ssh/authorized_keys
echo "ssh-rsa $sshkey0 newlaptopkey" >>~root/.ssh/authorized_keys

chown tljohnsn:tljohnsn ~tljohnsn/.ssh/authorized_keys /home/tljohnsn/.ssh
chown root:root ~root/.ssh/authorized_keys

chmod 600  ~tljohnsn/.ssh/authorized_keys ~root/.ssh/authorized_keys

echo "tljohnsn ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/010_tljohnsn-nopasswd
chmod 440 /etc/sudoers.d/010_tljohnsn-nopasswd
systemctl enable --now avahi-daemon
systemctl disable rsync

#Install repos
sudo wget https://enterprise.proxmox.com/debian/proxmox-release-trixie.gpg \
     -O /etc/apt/trusted.gpg.d/proxmox-release-trixie.gpg
wget -q -O - https://downloads.linux.hpe.com/SDR/hpePublicKey2048_key2.pub | \
    sudo gpg --dearmor -o /etc/apt/keyrings/hp-mcp.gpg


sudo echo "deb http://download.proxmox.com/debian/pbs trixie pbs-no-subscription" \
    | sudo tee -a /etc/apt/sources.list.d/proxmox-backup-server.list
echo "deb [signed-by=/etc/apt/keyrings/hp-mcp.gpg] https://downloads.linux.hpe.com/SDR/repo/mcp/debian trixie/current non-free" |sudo tee -a /etc/apt/sources.list.d/hp-mcp.list


apt update
apt -y install ssacli

mkdir -p /etc/proxmox-backup/certs.bak
cp /etc/proxmox-backup/proxy.pem /etc/proxmox-backup/certs.bak
cp /etc/proxmox-backup/proxy.key /etc/proxmox-backup/certs.bak
cp /root/piplayer/configfiles/wildcards.crt /etc/proxmox-backup/proxy.pem
cat ~/uwca/wildcards.key
cat >/etc/proxmox-backup/proxy.key
systemctl reload proxmox-backup-proxy

dd if=/dev/zero of=/safemount.img bs=4M count=1
mkfs.ext4 -L safemount /safemount.img
mkdir /safemount
mount -o loop /safemount.img /safemount
mkdir /safemount/aspace
sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
mkfs.ext4 -L aspace /dev/md0
mount -L aspace /safemount/aspace/


mkfs.ext4 -L space /dev/sda1
mkdir /space
mount -L space /space

#ssacli ctrl slot=1 modify dwc=enable forced
#ssacli ctrl slot=1 modify nbwc=enable

