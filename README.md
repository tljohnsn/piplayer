# piplayer

## Setup

* On the sd card create an empty file called ssh in /boot
* Place wpa_supplicant.conf in /boot
* Change default passwords in tunes.txt

```bash
ssh -A -o 'UserKnownHostsFile /dev/null' -o 'StrictHostKeyChecking no' pi@raspberrypi.local
git clone git@github.com:tljohnsn/piplayer.git
bash ~pi/piplayer/pi.sh
```

## Optional
### Configure bluetooth
```bash
pair-jbl-port.sh
```bash
