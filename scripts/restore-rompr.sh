#!/bin/bash
su chmod 777 /var/www/html/rompr/prefs/databackups/.
rsync -avP -e ssh trentj@hot.useractive.com:databackups/. /var/www/html/rompr/prefs/databackups/.
