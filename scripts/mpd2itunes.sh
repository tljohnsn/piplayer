#!/bin/bash
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
sed -i "s%mp3zpi%/Music/mp3zlaptop%g" $1
sed -i "s%convertedflacspi%/Music/convertedflacs%g" $1
