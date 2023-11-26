#!/bin/bash
if [ -f /usr/bin/rtorrent ]; then
    echo starting rtorrent
    su -c "screen -d -m -S rtorrent /usr/bin/rtorrent -b 0.0.0.0" - pi | tee -a /var/log/rtorrent.log &
fi
