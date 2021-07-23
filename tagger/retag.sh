#!/bin/bash
find /musictest -name "index.txt" -print0 | xargs -0 rm
#Tag mp3z
/Users/tljohnsn/piplayer/tagger/mp3z.pl
#Tag convertedflacs
/Users/tljohnsn/piplayer/tagger/tag-retag-mp3.pl
#Regenerate convertedflacs indexes
/Users/tljohnsn/piplayer/tagger/jukebox.pl
