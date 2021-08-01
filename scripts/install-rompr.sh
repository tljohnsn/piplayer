#!/bin/bash
#Install rompr
#https://fatg3erman.github.io/RompR/Installation-on-Linux-Alternative-Method.html
VERSION=1.59
#Don't forget to change version in sed command below

cd
if [ ! -f "rompr-$VERSION.zip" ]; then
    wget https://github.com/fatg3erman/RompR/releases/download/$VERSION/rompr-$VERSION.zip
fi
unzip -q rompr-$VERSION.zip
mkdir rompr/{prefs,albumart}
mkdir -p rompr/prefs/databackups
#This patch reduced accidental clicks when trying to re-order the playlist
patch rompr/ui/playlist.js piplayer/configfiles/playlist.diff
patch rompr/includes/prefs.class.php piplayer/configfiles/prefs.class.diff
cp -a ~pi/piplayer/backups/* rompr/prefs/databackups/.
sudo mv rompr /var/www/html
sudo chown -R www-data.www-data /var/www/html/rompr
curl -b "skin=desktop;currenthost=Default;player_backend=mopidy" -d '[{"action": "metabackup"}]' -H "Content-Type: application/json" -X POST  http://localhost/rompr/ >/dev/null
sudo sed -i -e 's/shownupdatewindow";s:0:""/shownupdatewindow";s:4:"1.59"/' /var/www/html/rompr/prefs/prefs.var
sudo sed -i -e 's/"infosource";s:6:"lastfm"/"infosource";s:4:"file"/' /var/www/html/rompr/prefs/prefs.var
sudo ln -s /home/ftp/local /var/www/html/rompr/prefs/MusicFolders
sudo chown -h www-data.www-data /var/www/html/rompr/prefs/MusicFolders
#sudo install -b -o www-data -g www-data -m 644 ~pi/piplayer/configfiles/prefs.var /var/www/html/rompr/prefs/prefs.var
