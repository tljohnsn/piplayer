#!/bin/bash
NOW=`date +'%s'`
LASTRUN=`date +'%s'`
PAST=`date +'%s'`
echo starting $NOW
LOCK="/tmp/watch.lock"
rm -f $LOCK
while [ 1 == 1 ]; do
    echo "Starting idle loop"
    while mpc idle database; do
	NOW=`date +'%s'`
	RUNDURATION=`expr $NOW - $LASTRUN`
	CHANGEDURATION=`expr $NOW - $PAST`
	echo it changed NOW: $NOW LASTRUN: $LASTRUN RUNDURATION: $RUNDURATION PAST: $PAST CHANGEDURATION: $CHANGEDURATION
	if [ ! -f "$LOCK" ]; then
	    touch $LOCK
	    echo "it was unlocked"
	    ~pi/piplayer/scripts/update-rompr.sh
	    rm -f $LOCK
	else
	    echo "it was locked"
	fi
#    if [[ ( $RUNDURATION -gt 10 ) && ( $CHANGEDURATION -gt 10 ) ]]; then
#	echo Rebuild the index
#	sleep 11
#	LASTRUN=`date +'%s'`
#    fi
	PAST=`date +'%s'`
    done
    sleep 5
done
