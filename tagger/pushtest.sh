#!/bin/bash
rsync='rsync -avP --inplace --no-W --exclude=.sync --exclude=.DS_Store --exclude=._* --delete'
echo $rsync
$rsync /musictest/convertedflacs/. /Music/convertedflacs/.
$rsync /musictest/mp3zlaptop/. /Music/mp3zlaptop/.
