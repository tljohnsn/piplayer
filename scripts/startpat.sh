#!/bin/bash
if [ -f /home/pi/pat/pat ]; then
    echo starting pat
    export pactor_debug=3
    su -c "pactor_debug=3 /home/pi/pat/pat http" - pi | tee -a /var/log/pat.log &
fi

touch /var/log/rigctld.log

if [ -c /dev/ttyUSB3 ]; then
    echo starting rigctld
    rigctld -m 3002 -r /dev/ttyUSB3 -v >>/var/log/rigctld.log 2>&1  &
else
    sleep 10
    rigctld -m 3002 -r /dev/ttyUSB3 -v >>/var/log/rigctld.log 2>&1  &
fi
