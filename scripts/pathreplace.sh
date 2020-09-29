#!/bin/bash

#Usage:
# cat Dr.\ Dog\ Type\ of\ stuff.itunes.m3u | /home/pi/piplayer/scripts/pathreplace.sh > Dr.\ Dog\ Type\ of\ stuff.mopidy.m3u

dos2unix -c mac | grep mp3 | xargs -d "\n" -n 1 basename | xargs -i -d "\n" -n 1 find /home/ftp/local -name {} |  sed -e "s%/home/ftp/local/%%g" | xargs -n 1 -d "\n" urlencode | sed -e "s/^/local:track:/g" -e "s:%2F:/:g"

#Replace paths
#sed -i  \
#    -e "s%/Users/tljohnsn/Public/music/convertedflacs%/home/ftp/local/convertedflacspi%" \
#    -e "s%/Users/tljohnsn/Public/music/mp3zlaptop%/home/ftp/local/mp3zpi%" \
#    $file
#sed -i \
#    -e "s%/Users/tljohnsn/Public/music/%local:track:%" \
#    -e "s%/home/ftp/local/%local:track:%" \
#    $file

#Hacky url encoding
#sed -i -e "s/ /%20/g" -e "s/(/%28/g" \
#    -e "s/)/%29/g" \
#    -e "s/,/%2C/g" \
#    -e "s/'/%27/g" $file
