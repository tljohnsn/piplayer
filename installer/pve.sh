#apt -y install emacs-nox sudo rsyslog libnss-mdns git pv gpg curl

apt update
apt -y install ssacli lvm2 vdo thin-provisioning-tools

#cat ~/uwca/wildcards.key
#cat >/etc/proxmox-backup/proxy.key

lvcreate --type thin-pool -n data -L 2T --pooldatavdo y  --discards passdown vg0
lvextend -L 100T vg0/data
lvcreate  -V 10t -T vg0/data -n images
lvcreate  -V 1t -T vg0/data -n vm-downloads
mkfs.ext4 -K -L images /dev/vg0/images
mkfs.ext4  -L images /dev/vg0/images
mkdir -p /images

echo "/dev/vg0/images /images ext4 defaults,nofail,_netdev 1 2" >> /etc/fstab
mount -a

cp /root/piplayer/configfiles/pve-install-repo.sources /etc/apt/sources.list.d
wget https://enterprise.proxmox.com/debian/proxmox-archive-keyring-trixie.gpg \
     -O/usr/share/keyrings/proxmox-archive-keyring.gpg

mkdir -p /etc/systemd/system/networking.service.d/
echo '[Service]
TimeoutStartSec=10sec' >>/etc/systemd/system/networking.service.d/override.conf

apt update && apt -y full-upgrade
apt -y install proxmox-default-kernel

reboot

apt -y install proxmox-ve open-iscsi chrony
echo "Enabled: no" | tee -a /etc/apt/sources.list.d/pve-enterprise.sources
apt -y remove linux-image-amd64 'linux-image-6.12*' os-prober
update-grub

cp /root/piplayer/configfiles/wildcards.crt /etc/pve/local/pveproxy-ssl.pem
cp /root/wildcard.key /etc/pve/local/pveproxy-ssl.key
systemctl restart pveproxy

pvesm add dir images --path /images --content images,iso,backup --is_mountpoint 1
pvesm add lvmthin local-lvm --vgname vg0 --thinpool data --content images
pvesm add pbs pve1 --server pve1.trentjohnson.net --datastore aspace --username root@pam \
      --fingerprint cd:88:3f:3d:78:3a:8d:5b:d0:28:a9:c2:e0:9f:d1:1f:49:b7:26:b9:a8:36:d4:93:4c:0c:5e:ac:78:4f:ac:10 \
      --password

cp /etc/network/interfaces /root
sed -i -e "s/inet dhcp/inet manual/g" -e "s/inet6 auto/inet6 manual/g" /etc/network/interfaces
LDQ=`/sbin/ip addr show | awk '/10.0.2/ {print $2}' | sed -e 's/10.0.2.//g' | sed -e 's/\/24//g'`
SHOST=`hostname -s`
echo "
auto vmbr0
iface vmbr0 inet6 auto
iface vmbr0 inet static
	address 10.0.2.$LDQ/24
	gateway 10.0.2.1
	bridge-ports eno1
	bridge-stp off
	bridge-fd 0
	bridge-vlan-aware yes
	bridge-vids 2-4094
" | sudo tee -a /etc/network/interfaces
echo "10.0.2.$LDQ $SHOST.trentjohnson.net $SHOST" | sudo tee -a /etc/hosts
echo "net.ipv6.conf.vmbr0.accept_ra=2" >/etc/sysctl.d/ipv6.conf

ifreload -a

wget https://raw.githubusercontent.com/foundObjects/pve-nag-buster/master/install.sh
sudo bash install.sh

