#!/bin/bash

file=$1

#Convert the newlines
dos2unix -c mac $file

#Replace paths
sed -i  \
    -e "s%/Users/tljohnsn/Public/music/convertedflacs%convertedflacspi%" \
    -e "s%/Users/tljohnsn/Public/music/mp3zlaptop%mp3zpi%" \
    $file
