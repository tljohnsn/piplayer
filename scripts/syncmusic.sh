#!/bin/bash
rsync -avP --delete --exclude=.sync --exclude=.DS_Store --exclude=._* /Music/convertedflacs/. /Volumes/public/convertedflacspi/.
rsync -avP --exclude=.sync --exclude=.DS_Store --exclude=._* --delete /Music/mp3zlaptop/. /Volumes/public/mp3zpi/.
