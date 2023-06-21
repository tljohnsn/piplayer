#!/bin/bash
echo "select Tracktable.Uri From Ratingtable, Tracktable where Ratingtable.TTindex = Tracktable.TTindex and Ratingtable.Rating >2;" | sqlite3 /var/www/html/rompr/prefs/collection.sq3 | sed -e "s%mp3zpi%/Music/mp3zlaptop%g" -e "s%convertedflacspi%/Music/convertedflacs%g" | shuf
