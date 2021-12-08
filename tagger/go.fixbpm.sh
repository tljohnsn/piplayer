#!/bin/bash
cd ~/piplayer/tagger
git pull
cp ~/piplayer/tagger/config.yaml ~/.config/beets

echo "remove old music and database" 
rm -rf ~/mp3zrenamed/* ~/data/musiclibrary.db
echo "begin the import"
beet import -w -C -A -q ~/mp3zstaging
echo "alalyse bpm"
beet bpmanalyser -w bpm:0
echo "writing bpm"
beet write
echo "remove sort tags"
find  ~/mp3zstaging -name "*.mp3" -print0 | xargs -0 mid3v2 --delete-frames=TXXX:ALBUMARTISTSORT,TSOP,TSOC
find ~/mp3zstaging -name cover.?.jpg -print0 |xargs -0 rm

echo "now run:"
cd ~/mp3zstaging
echo "find . -type f -name "*.mp3" -print0 | xargs -0 -I {}  rsync -avP {}  /Music/mp3zlaptop/{}"
