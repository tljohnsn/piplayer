#!/bin/bash
media_dir=`sudo mopidyctl config |grep media_dir | cut -d = -f 2 | sed -e 's/\s//g'`
numfiles=`find /home/ftp/local -type f -name "*.mp3" |wc -l`
echo "found $numfiles files in /home/ftp/local"
loops=`echo $(( numfiles / 1000 ))`
for i in $(seq 0 $loops); do
    echo $i
    sudo mopidyctl local scan --limit=1000
done

sudo cp ~pi/piplayer/playlists/*.mopidy.m3u /home/ftp/local/playlists/
sudo chmod 777 /home/ftp/local/playlists/*
sudo mopidyctl local scan
