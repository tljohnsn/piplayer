#!/bin/bash
sleep 10
device=`bluetoothctl devices | cut -d " " -f 2`
bluetoothctl connect $device
aplay /usr/share/sounds/alsa/Front_Left.wav
mpc enable 1
mpc crossfade 10
mpc consume on
mpc volume 80%
