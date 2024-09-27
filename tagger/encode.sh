#!/bin/bash
#ffmpeg -i "$1" -f wav - | lame -V 0 --noreplaygain - "$2"
ffmpeg -i "$1" -f wav - | lame -b 320 --noreplaygain - "$2"
