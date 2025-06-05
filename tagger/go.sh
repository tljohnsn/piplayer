#!/bin/bash
if [ -x /usr/local/bin/mid3v2 ]; then
    mid3v2=/usr/local/bin/mid3v2
fi

if [ -x /usr/local/opt/ffmpeg\@4/bin/ffmpeg ]; then
    echo "Use ffmpeg4"
    export PATH="/usr/local/opt/ffmpeg@4/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/ffmpeg@4/lib"
    export CPPFLAGS="-I/usr/local/opt/ffmpeg@4/include"
fi

if [ -x $HOME/Library/Python/3.9/bin/mid3v2 ]; then
    mid3v2=$HOME/Library/Python/3.9/bin/mid3v2
fi
find ~/mp3zstaging -name "*.mp3"  -print0 | xargs -0 $mid3v2 --delete-v1 \
    --delete-frames=TXXX:Uploader,TXXX:Credits,TCOP,TENC,TIT1,TPE3,TSSE,TXXX:RELEASECOUNTRY,COMM,USLT,TXXX:Provider
if [ -x ~/bin/apetag ]; then
    find ~/mp3zstaging -name "*.mp3" -print0 | xargs -0 -n 1 -I {} ~/bin/apetag -i {} -m erase >/dev/null
fi
cd ~/piplayer/tagger
echo "Updating tagging script to latest version in github..."
git pull
echo
echo "Installing the latest beets config file from github..."
cp ~/piplayer/tagger/config.yaml ~/.config/beets
echo
echo "Removing old music from mp3zrenamed and beets database..." 
rm -rf ~/mp3zrenamed/* ~/data/musiclibrary.db
echo
echo "Starting the beets import to tag and rename the files..."
beet import -w -c ~/mp3zstaging
echo
echo "Using beet bpmanalyser to calculate beats per minute in tracks..."
beet bpmanalyser -w bpm:0
echo 
echo "Writing bpm to the tags in files..."
beet write
echo
echo "Using mid3v2 to remove sort tags..."
find  ~/mp3zrenamed -name "*.mp3" -print0 | xargs -0 $mid3v2 --delete-v1 --delete-frames=TXXX:ALBUMARTISTSORT,TSOP,TSOC
find ~/mp3zrenamed -name cover.?.jpg -print0 |xargs -0 rm
open ~/mp3zrenamed
echo
echo 
echo "All done"
echo
echo 
echo "Look in mp3zrenamed:"
echo "  Do the folders look like 'Artist - Album'?"
echo "  Are the tracks named like '01 Track Name.mp3'?"
echo "  Do all the tracks have cover art?"
echo
echo "If everything looks good, drag the folders from mp3zrenamed into mp3zlaptop"
echo 
echo "now run this command to send files from mp3zlaptop to tunes:"
echo " ~/piplayer/tagger/syncssh.sh"
echo " ~/piplayer/tagger/mbpsync.sh"
echo " mpc update"
echo " mpc add mp3zpi/Square\ One\ -\ In\ Full\ Bloom/10\ Kitty\ Cat.mp3"
