#!/bin/bash
rm -rf ~/mp3zrenamed/* ~/data/musiclibrary.db
beet import -w -c ~/staging
find  ~/mp3zrenamed -name "*.mp3" -print0 | xargs -0 mid3v2 --delete-frames=TXXX:ALBUMARTISTSORT,TSOP,TSOC
find ~/mp3zrenamed -name cover.?.jpg -print0 |xargs -0 rm
