#!/bin/bash
date="2023-07-12"
date=`date +%Y-%m-%d`
for i in {2..4}; do
    outfile=`echo /home/ftp/local/playlists/$((i+1))plus${date}.itunes.m3u`
    echo $outfile
    echo "select Tracktable.Uri From Ratingtable, Tracktable where Ratingtable.TTindex = Tracktable.TTindex and Ratingtable.Rating >$i;" | sqlite3 /var/www/html/rompr/prefs/collection.sq3 | sed -e "s%mp3zpi%/Music/mp3zlaptop%g" -e "s%convertedflacspi%/Music/convertedflacs%g" | shuf >$outfile
done

for i in {0..1}; do
    outfile=`echo /home/ftp/local/playlists/$((i+1))plus${date}.itunes.m3u`
    echo $outfile
    echo "select Tracktable.Uri From Ratingtable, Tracktable where Ratingtable.TTindex = Tracktable.TTindex and Ratingtable.Rating =$i+1;" | sqlite3 /var/www/html/rompr/prefs/collection.sq3 | sed -e "s%mp3zpi%/Music/mp3zlaptop%g" -e "s%convertedflacspi%/Music/convertedflacs%g" >$outfile
done
