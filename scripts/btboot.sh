#!/bin/bash
sleep 10
device=`bluetoothctl devices | cut -d " " -f 2`
bluetoothctl connect $device
aplay /usr/share/sounds/alsa/Front_Center.wav
