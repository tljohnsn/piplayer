#apt -y install emacs-nox sudo rsyslog libnss-mdns git pv gpg curl

apt update
apt -y install ssacli

apt -y install rdnssd ndisc6
rdisc6 ens18

apt install proxmox-backup-server

mkdir -p /etc/proxmox-backup/certs.bak
cp /etc/proxmox-backup/proxy.pem /etc/proxmox-backup/certs.bak
cp /etc/proxmox-backup/proxy.key /etc/proxmox-backup/certs.bak
cp /root/piplayer/configfiles/wildcards.crt /etc/proxmox-backup/proxy.pem
cp /root/wildcard.key /etc/proxmox-backup/proxy.key
systemctl reload proxmox-backup-proxy

#cat ~/uwca/wildcards.key
#cat >/etc/proxmox-backup/proxy.key

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
mount -a

#ssacli ctrl slot=1 modify dwc=enable forced
#ssacli ctrl slot=1 modify nbwc=enable

wget https://raw.githubusercontent.com/foundObjects/pve-nag-buster/master/install.sh
sudo bash install.sh
echo "" | tee /etc/motd

STORE=96space
STORE=aspace
proxmox-backup-manager datastore create $STORE /safemount/aspace --prune-schedule 22:00   --gc-schedule 22:15 --keep-last 14 --keep-monthly 36
proxmox-backup-manager verify-job create 001 --store $STORE --schedule 22:30   --read-threads 3 --verify-threads 12

proxmox-backup-manager remote create pbs --host pbs.trentjohnson.net --auth-id root@pam \
  --fingerprint cd:88:3f:3d:78:3a:8d:5b:d0:28:a9:c2:e0:9f:d1:1f:49:b7:26:b9:a8:36:d4:93:4c:0c:5e:ac:78:4f:ac:10 \
  --password 'aaaa'
