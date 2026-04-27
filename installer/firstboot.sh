#!/bin/bash
apt -y install ifupdown2 emacs-nox sudo
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

echo "Enabled: no" | tee -a /etc/apt/sources.list.d/pve-enterprise.sources

sed -i -e "s/enterprise.proxmox/download.proxmox/" /etc/apt/sources.list.d/ceph.sources
sed -i -e "s/enterprise/no-subscription/"  /etc/apt/sources.list.d/ceph.sources


echo "set enable-bracketed-paste off" | tee -a /etc/inputrc
