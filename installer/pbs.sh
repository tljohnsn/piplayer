
#apt -y install emacs-nox sudo rsyslog libnss-mdns git pv gpg curl
apt -y install rdnssd
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
#cat ~/uwca/wildcards.key
#cat >/etc/proxmox-backup/proxy.key
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

echo "/safemount.img /safemount ext4 defaults,nofail 0 2" >> /etc/fstab
echo "LABEL=aspace /safemount/aspace ext4 defaults,nofail 0 3" >> /etc/fstab


#ssacli ctrl slot=1 modify dwc=enable forced
#ssacli ctrl slot=1 modify nbwc=enable

