#!/bin/bash
#pip3 install torrent_parser
echo "Torrent name $1" >>/tmp/dlcomplete.txt
echo "Root path $2"  >>/tmp/dlcomplete.txt
echo "Tracker $3"   >>/tmp/dlcomplete.txt
echo "Id $4"  >>/tmp/dlcomplete.txt
tracker=`echo "$3" | cut -d / -f 3`
if [ "$tracker" == "flacsfor.me" ]; then
    echo "Its from red" >>/tmp/dlcomplete.txt
    cp -a "$2" /Users/tljohnsn/mp3zstaging
    cp -a "$2" /Users/tljohnsn/red/download
osascript - "/Users/tljohnsn/piplayer/tagger/go.sh" <<EOF
on run argv
tell application "iTerm"
    activate
    set new_term to (create window with default profile)
    tell new_term
        tell the current session
            repeat with arg in argv
               write text arg
            end repeat
        end tell
    end tell
end tell
end run
EOF
fi