#!/bin/bash
latest=`ssh trentj@hot.useractive.com ls -tr databackups | tail -n 1`
if [ ! -z "$latest" ]; then  
    rsync -avP -e ssh trentj@hot.useractive.com:databackups/$latest /tmp
    sudo mv /tmp/$latest /var/www/html/rompr/prefs/databackups
else
    echo $latest error
fi
