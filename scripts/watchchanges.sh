#!/bin/bash
#!/bin/bash
NOW=`date +'%s'`
LASTRUN=`date +'%s'`
while inotifywait -r -e modify -e create -e delete /home/ftp/local >/dev/null 2>&1; do
    NOW=`date +'%s'`
    RUNDURATION=`expr $NOW - $LASTRUN`
    CHANGEDURATION=`expr $NOW - $PAST`
    echo it changed NOW: $NOW LASTRUN: $LASTRUN RUNDURATION: $RUNDURATION PAST: $PAST CHANGEDURATION: $CHANGEDURATION
    if [[ ( $RUNDURATION -gt 10 ) && ( $CHANGEDURATION -gt 10 ) ]]; then
	echo Rebuild the index
	sleep 11
	LASTRUN=`date +'%s'`
    fi
    PAST=`date +'%s'`
done
