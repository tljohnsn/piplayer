#!/bin/bash
if [ -e /dev/ttyACM0 ]; then
    gpsd /dev/ttyACM0 -G -n
fi

if [ -e /dev/ttyAMA0 ]; then
    echo ama0
#    gpsd /dev/ttyAMA0 -G
fi
