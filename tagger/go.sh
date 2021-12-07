#!/bin/bash
cd ~/piplayer/tagger
git pull
cp ~/piplayer/tagger/config.yaml ~/.config/beets

echo "remove old music and database" 
rm -rf ~/mp3zrenamed/* ~/data/musiclibrary.db
echo "begin the import"
beet import -w -c ~/mp3zstaging
echo "alalyse bpm"
beet bpmanalyser -w bpm:0
echo "writing bpm"
beet write
echo "remove sort tags"
find  ~/mp3zrenamed -name "*.mp3" -print0 | xargs -0 mid3v2 --delete-frames=TXXX:ALBUMARTISTSORT,TSOP,TSOC
find ~/mp3zrenamed -name cover.?.jpg -print0 |xargs -0 rm

echo "now run:"
echo " ~/piplayer/tagger/syncssh.sh"
