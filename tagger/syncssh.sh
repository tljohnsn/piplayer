#!/bin/bash
src="/Music"
dst="pi@tunes.local:/home/ftp/local"
rsync='rsync -avP --exclude=.sync --exclude=.DS_Store --exclude=._* --delete'
#echo $rsync

$rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" $src/convertedflacs/. $dst/convertedflacspi/.
$rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" $src/mp3zlaptop/. $dst/mp3zpi/.

#ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null pi@tunes.local sudo /etc/cron.daily/mopidylocalscan
