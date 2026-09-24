
#apt -y install emacs-nox sudo rsyslog libnss-mdns git pv gpg curl
apt -y install rdnssd

apt update
apt -y install ssacli

mkdir -p /etc/proxmox-backup/certs.bak
cp /etc/proxmox-backup/proxy.pem /etc/proxmox-backup/certs.bak
cp /etc/proxmox-backup/proxy.key /etc/proxmox-backup/certs.bak
cp /root/piplayer/configfiles/wildcards.crt /etc/proxmox-backup/proxy.pem
cp /root/wildcard.key /etc/proxmox-backup/proxy.key
#cat ~/uwca/wildcards.key
#cat >/etc/proxmox-backup/proxy.key
systemctl reload proxmox-backup-proxy

dd if=/dev/zero of=/safemount.img bs=4M count=1
mkfs.ext4 -L safemount /safemount.img
mkdir /safemount
mount -o loop /safemount.img /safemount
mkdir /safemount/aspace
sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sdb4 /dev/sdc4 /dev/sdd4 /dev/sde4
mkfs.ext4 -L aspace /dev/md0
mount -L aspace /safemount/aspace/


mkfs.ext4 -L space /dev/sda1

echo "/safemount.img /safemount ext4 defaults,nofail 0 2" >> /etc/fstab
echo "LABEL=aspace /safemount/aspace ext4 defaults,nofail 0 3" >> /etc/fstab


#ssacli ctrl slot=1 modify dwc=enable forced
#ssacli ctrl slot=1 modify nbwc=enable

