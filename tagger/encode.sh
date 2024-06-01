#!/bin/bash
#ffmpeg -i "$1" -f wav - | lame -V 4 - "$2"
ffmpeg -i "$1" -f wav - | lame -b 320 - "$2"
