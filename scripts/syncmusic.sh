#!/bin/bash
rsync -a --delete --exclude=.sync --exclude=.DS_Store --exclude=._* /Music/convertedflacs/. /Volumes/public/convertedflacspi/.
rsync -a --exclude=.sync --exclude=.DS_Store --exclude=._* --delete /Music/mp3zlaptop/. /Volumes/public/mp3zpi/.
