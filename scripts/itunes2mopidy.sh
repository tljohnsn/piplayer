#!/bin/bash

file=$1

#Convert the newlines
dos2unix -c mac $file

#Replace paths
sed -i  \
    -e "s%/Users/tljohnsn/Public/music/convertedflacs%/home/ftp/local/convertedflacspi%" \
    -e "s%/Users/tljohnsn/Public/music/mp3zlaptop%/home/ftp/local/mp3zpi%" \
    $file
sed -i \
    -e "s%/Users/tljohnsn/Public/music/%local:track:%" \
    -e "s%/home/ftp/local/%local:track:%" \
    $file

#Hacky url encoding
sed -i -e "s/ /%20/g" -e "s/(/%28/g" \
    -e "s/)/%29/g" \
    -e "s/,/%2C/g" \
    -e "s/'/%27/g" $file
