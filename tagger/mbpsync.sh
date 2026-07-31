#!/bin/bash
#mkdir -p ~/red/{download,adtorrent2}
#rsync -avP --del -e ~/bin/nssh trentj@server18.trentjohnson.net:rtorrent/watch/load/. ~/red/adtorrent2/.
#xrsync -avP --del -e ~/bin/nssh trentj@server18.trentjohnson.net:rtorrent/download/. ~/red/download/.

/usr/local/bin/rsync -avP --iconv=utf-8-mac,utf-8 --exclude=.sync --exclude=.DS_Store ~/red/download/. trentj@server18.trentjohnson.net:rtorrent/download/.
rsync -avP --exclude=.DS_Store ~/red/adtorrent2/. trentj@server18.trentjohnson.net:rtorrent/watch/load/.

ssh -A trentj@server18.trentjohnson.net rsync -avP rtorrent/download/. server25.trentjohnson.net:rtorrent/download/.
rsync -avP ~/red/adtorrent2/. trentj@server25.trentjohnson.net:rtorrent/watch/load/.

