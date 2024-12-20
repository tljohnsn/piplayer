# piplayer

## Setup

* Latest instructions for bookworm 32 bit desktop 1.23GB image
* Image customizations to always use :
  * Set Hostname tunes
  * Allow public key auth and set the key to newlaptopkey
  * Set username and password to pi
  * Configure wirelss lan Jupiter
  * Set local settings US/Eastern
  * Play Sound when finished
  * Don't eject
* Burn the image
* Change default passwords in tunes.txt and copy to /boot

```bash
ssh -A -o 'UserKnownHostsFile /dev/null' -o 'StrictHostKeyChecking no' pi@raspberrypi.local
git clone git@github.com:tljohnsn/piplayer.git
bash ~pi/piplayer/pi.sh
```

## Optional
### Configure bluetooth
* This uses the mac address configured in /boot/tunes.txt for pairing

```bash
piplayer/scripts/pair-jbl-port.sh
```

### Install pat for ham radio
```bash
#Do not run as root
cd ~pi
piplayer/scripts/install-pat.sh
```

### Block chartplotter internet access
```bash
sudo ~/piplayer/scripts/consortmasq.sh wlanboard
```

### Add ssh key for rompr backup
```bash
sudo su - root
ssh-keygen -t rsa
ssh-copy-id trentj@hot.useractive.com
```

### Configure another hotspot
```bash
nmcli --ask device wifi connect "Verizon-MiFi8800L-CF30"
```
