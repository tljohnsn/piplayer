#!/bin/bash
numfiles=`find /home/ftp/local -type f -name "*.mp3" |wc -l`
echo "found $numfiles files in /home/ftp/local"
loops=`echo $(( numfiles / 1000 ))`
for i in $(seq 0 $loops); do
    echo $i
    echo mopidyctl local scan --limit=1000
done

