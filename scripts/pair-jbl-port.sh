#!/bin/bash
bt_addr=00:42:79:D5:49:2B
source /boot/tunes.txt

#Pair the device
expect -f ~pi/piplayer/scripts/btpair.expect $bt_addr

#Test the sound
aplay /usr/share/sounds/alsa/Front_Right.wav
