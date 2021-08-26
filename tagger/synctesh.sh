#!/bin/bash
rsync='rsync -avP --inplace --no-W --exclude=.sync --exclude=.DS_Store --exclude=._* --delete'
echo $rsync
$rsync /Music/convertedflacs/. /musictest/convertedflacs/.
$rsync /Music/mp3zlaptop/. /musictest/mp3zlaptop/.
