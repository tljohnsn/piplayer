#!/bin/bash
if [ $UID = 0 ]; then
   killall rigctld
   /home/pi/hamlib-3.3/tests/.libs/rigctld -m 3002 -r /dev/ttyUSB3 -v >>/var/log/rigctld.log 2>&1  &
else
    sudo ~pi/bin/rig.sh
fi
