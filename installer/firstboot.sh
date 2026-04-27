#!/bin/bash
touch /root/trent.was.here
sed -i -e "s/bridge-fd 0/bridge-fd 0\n\tbridge-vlan-aware yes\n\tbridge-vids 2-4094/" /etc/network/interfaces
echo "thunderbolt" | tee -a /etc/modules
echo "thunderbolt-net" | tee -a /etc/modules

echo "Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
" | tee /etc/apt/sources.list.d/proxmox.sources

echo "KexAlgorithms +diffie-hellman-group1-sha1
PubkeyAcceptedAlgorithms=+ssh-rsa
HostKeyAlgorithms=+ssh-rsa
" | tee -a /etc/ssh/sshd_config

echo "HostKeyAlgorithms=+ssh-rsa
PubkeyAcceptedAlgorithms=+ssh-rsa
" | tee -a /etc/ssh/ssh_config

echo "Enabled: no" | tee -a /etc/apt/sources.list.d/pve-enterprise.sources

sed -i -e "s/enterprise.proxmox/download.proxmox/" /etc/apt/sources.list.d/ceph.sources
sed -i -e "s/enterprise/no-subscription/"  /etc/apt/sources.list.d/ceph.sources


echo "set enable-bracketed-paste off" | tee -a /etc/inputrc

apt -y update
apt -y install ifupdown2 emacs-nox sudo rsyslog libnss-mdns git \
    proxmox-auto-install-assistant xorriso simple-cdd build-essential net-tools

git clone https://github.com/tljohnsn/piplayer.git /root/piplayer
ln -s /root/piplayer/installer/answer.toml /root
ln -s piplayer/installer/firstboot.sh /root

cat ~/piplayer/configfiles/bashrc.txt >>~root/.bashrc
cat ~/piplayer/configfiles/bashrc.txt >>/etc/skel/.bashrc

useradd -m -s /bin/bash -u 1025 -p "$y$j9T$T4hKMWt/iUBHQ15MpKjG31$MgIwrN16i2tleH1GLg4lwh6e3LeuIlMo2C9rc8gcPnD" tljohnsn
mkdir -p /home/tljohnsn/.ssh
cp /root/.ssh/authorized_keys /home/tljohnsn/.ssh
chown tljohnsn /home/tljohnsn/.ssh/authorized_keys

echo "tljohnsn ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/010_tljohnsn-nopasswd
chmod 440 /etc/sudoers.d/010_tljohnsn-nopasswd
systemctl enable --now avahi-daemon
systemctl disable rsync

echo "" | tee /etc/motd

mkdir -p /etc/systemd/system/getty@tty1.service.d
echo "[Service]" | tee /etc/systemd/system/getty@tty1.service.d/noclear.conf
echo "TTYVTDisallocate=no" | tee -a /etc/systemd/system/getty@tty1.service.d/noclear.conf
echo ExecStart= | tee -a /etc/systemd/system/getty@tty1.service.d/noclear.conf
echo ExecStart=-/sbin/agetty --noclear %I $TERM | tee -a /etc/systemd/system/getty@tty1.service.d/noclear.conf

lvcreate -n images -L200G pve
mkfs.ext4 -L images  /dev/pve/images
mkdir /images
echo "/dev/pve/images /images ext4 defaults 1 2" | tee -a /etc/fstab
mount -a
pvesm add dir images --path /images --content images,iso,backup --is_mountpoint 1


