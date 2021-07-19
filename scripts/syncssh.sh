#!/bin/bash
rsync='rsync -avP --inplace --exclude=.sync --exclude=.DS_Store --exclude=._*'
echo $rsync
$rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /Music/convertedflacs/. pi@tunes.local:/home/ftp/local/convertedflacspi/.
$rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /Music/mp3zlaptop/. pi@tunes.local:/home/ftp/local/mp3zpi/.
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null pi@tunes.local sudo /etc/cron.daily/mopidylocalscan
