#!/bin/bash
#apt -y install libnss-mdns
echo "set enable-bracketed-paste off" | tee -a /etc/inputrc

echo "KexAlgorithms +diffie-hellman-group1-sha1
PubkeyAcceptedAlgorithms=+ssh-rsa
HostKeyAlgorithms=+ssh-rsa
" | tee -a /etc/ssh/sshd_config

echo "HostKeyAlgorithms=+ssh-rsa
PubkeyAcceptedAlgorithms=+ssh-rsa
" | tee -a /etc/ssh/ssh_config

#apt -y install emacs-nox sudo rsyslog libnss-mdns git pv gpg curl
#apt -y install fupdown2 rdnssd
#git clone https://github.com/tljohnsn/piplayer.git /root/piplayer
cat /root/piplayer/configfiles/bashrc.txt >>~root/.bashrc
cat /root/piplayer/configfiles/bashrc.txt >>/etc/skel/.bashrc
cat /root/piplayer/configfiles/bashrc.txt >>/home/tljohnsn/.bashrc

#setup keys
mkdir -p /home/tljohnsn/.ssh /etc/skel/.ssh
sshkey0=`grep ^sshkey0 /root/piplayer/pi.sh | cut -c 9-`
echo "ssh-rsa $sshkey0 newlaptopkey" >>~tljohnsn/.ssh/authorized_keys
echo "ssh-rsa $sshkey0 newlaptopkey" >>~root/.ssh/authorized_keys
echo "ssh-rsa $sshkey0 newlaptopkey" >>/etc/skel/.ssh/authorized_keys

chown tljohnsn:tljohnsn ~tljohnsn/.ssh/authorized_keys /home/tljohnsn/.ssh
chown root:root ~root/.ssh/authorized_keys

chmod 600  ~tljohnsn/.ssh/authorized_keys ~root/.ssh/authorized_keys /etc/skel/.ssh/authorized_keys

echo "tljohnsn ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/010_tljohnsn-nopasswd
chmod 440 /etc/sudoers.d/010_tljohnsn-nopasswd

useradd -m -s /bin/bash -p "\$6\$GFR2qgCW2m7uyFm6\$HK3LUvwlpN8iVae31zHPcPs6qO7kuVIcupz1VWGCd3s1hhVMlifml.1EJoxWpC6p3WaiBgTIjy1DBcnP.Kxqz0" pi
echo "pi ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/010_pi-nopasswd
chmod 440 /etc/sudoers.d/010_pi-nopasswd

useradd -m -s /bin/bash -u 9806 -p "\$6\$GFR2qgCW2m7uyFm6\$HK3LUvwlpN8iVae31zHPcPs6qO7kuVIcupz1VWGCd3s1hhVMlifml.1EJoxWpC6p3WaiBgTIjy1DBcnP.Kxqz0" trentj

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

#Stop the screen clearing
mkdir -p /etc/systemd/system/getty@tty1.service.d
echo "[Service]" | tee /etc/systemd/system/getty@tty1.service.d/noclear.conf
echo "TTYVTDisallocate=no" | tee -a /etc/systemd/system/getty@tty1.service.d/noclear.conf
echo ExecStart= | tee -a /etc/systemd/system/getty@tty1.service.d/noclear.conf
echo ExecStart=-/sbin/agetty --noclear %I $TERM | tee -a /etc/systemd/system/getty@tty1.service.d/noclear.conf

#Put grub on the serial console
echo "GRUB_TERMINAL=\"console serial\"" >/etc/default/grub.d/99-serial.cfg
echo "GRUB_SERIAL_COMMAND=\"serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1\"" >>/etc/default/grub.d/99-serial.cfg
update-grub

wget http://ac.trentjohnson.net/tunes.txt -O /boot/tunes.txt
wget http://ac.trentjohnson.net/wildcard.key -O /root/wildcard.key
wget http://ac.trentjohnson.net//hostkeys.deb -O /root/hostkeys.tgz

cd /etc/ssh
tar -xzf /root/hostkeys.tgz

