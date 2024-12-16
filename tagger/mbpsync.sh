#!/bin/bash
#mkdir -p ~/red/{download,adtorrent2}
#rsync -avP --del -e ~/bin/nssh trentj@server17.useractive.com:rtorrent/watch/load/. ~/red/adtorrent2/.
#xrsync -avP --del -e ~/bin/nssh trentj@server17.useractive.com:rtorrent/download/. ~/red/download/.

/usr/local/bin/rsync -avP --iconv=utf-8-mac,utf-8 ~/red/download/. trentj@server17.useractive.com:rtorrent/download/.
rsync -avP --del ~/red/adtorrent2/. trentj@server17.useractive.com:rtorrent/watch/load/.

ssh -A trentj@server17.useractive.com rsync -avP rtorrent/download/. server18:rtorrent/download/.
rsync -avP --del ~/red/adtorrent2/. trentj@server18.useractive.com:rtorrent/watch/load/.

