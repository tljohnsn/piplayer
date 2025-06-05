#!/bin/bash
ffmpeg -i "$1" -f wav - | lame -V 0 --noreplaygain - "$2"
#ffmpeg -i "$1" -f wav - | lame -b 320 --noreplaygain - "$2"
#echo ffmpeg -i \""$1"\" -acodec alac "$2" >>/tmp/convert.out
#ffmpeg -i "$1" -f wav - | ffmpeg -acodec alac "$2"
