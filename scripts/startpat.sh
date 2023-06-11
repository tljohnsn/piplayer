#!/bin/bash
if [ -f /usr/bin/pat ]; then
    echo starting pat
    export pactor_debug=1
    su -c "pactor_debug=1 /usr/bin/pat http" - pi | tee -a /var/log/pat.log &
fi

touch /var/log/rigctld.log

if [ -c /dev/ttyUSB3 ]; then
    echo starting rigctld
    rigctld -m 3002 -r /dev/ttyUSB3 -v >>/var/log/rigctld.log 2>&1  &
fi
