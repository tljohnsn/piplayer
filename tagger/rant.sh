rsync -avP -e ~/bin/nssh /Users/tljohnsn/Desktop/musictemp/. vacation@tepid1.userworld.com:rtorrent/download/.
find /Users/tljohnsn/Downloads/ -name "*.torrent" -mmin -60 -print0 | xargs -0 -I {} rsync -avP -e ~/bin/nssh {} vacation@tepid1.userworld.com:rtorrent/watch/start/.
