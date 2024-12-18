#!/bin/bash
sleep 10
if [ -e /dev/ttyACM0 ]; then
    gpsd /dev/ttyACM0 -G -n
fi

if [ -e /dev/ttyAMA0 ]; then
    echo ama0
#    gpsd /dev/ttyAMA0 -G
fi

screen -d -m -S cgps /usr/bin/cgps

