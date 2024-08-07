#!/bin/bash
for file in *.mp3
do
    if [[ -d $file ]]
    then
        continue    # skip directories
    fi
    #    if [[ $file =~ ^[0-9]{2}\ (.*).mp3$ ]]    # get basename two digit
    if [[ $file =~ ^[0-9]{2}\ (.*).mp3$ ]]    # get basename
    then
        name=${BASH_REMATCH[1]}                # of a previously shuffled file
    else
        name=${file%.mp3}                      # of an unshuffled file
    fi
    if [[ $1 != -u ]]
    then
        mv "$file" "$(printf "%03d" ${RANDOM:0:3}) $name.mp3"    # shuffle
    else
        if [[ ! -e "$file.mp3" ]]
        then
            mv "$file" "$name.mp3"                           # unshuffle
        fi
    fi
done
