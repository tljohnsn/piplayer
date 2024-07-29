ssh -A macmini.local rsync -avP -e ~/bin/nssh /Users/tljohnsn/Movies/Torrents/. pi@tunes.local:rtorrent/download/.
ssh -A macmini.local rsync -avP -e ~/bin/nssh /Users/tljohnsn/Movies/Torrents/adtorrent2/. pi@tunes.local:rtorrent/watch/load/.

ssh -A macmini.local rsync -avP -e ~/bin/nssh /Users/tljohnsn/Movies/Torrents/. trentj@server17.useractive.com:rtorrent/download/.
ssh -A macmini.local rsync -avP -e ~/bin/nssh /Users/tljohnsn/Movies/Torrents/adtorrent2/. trentj@server17.useractive.com:rtorrent/watch/load/.

ssh -A trentj@server17.useractive.com rsync -avP rtorrent/download/. server18:rtorrent/download/.
ssh -A trentj@server18.useractive.com cp rtorrent/download/adtorrent2/*.torrent rtorrent/watch/load/
