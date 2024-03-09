#!/bin/bash
#https://ben.akrin.com/gnuplot-one-liner-from-hell/
#export width=`stty size | cut -d " " -f2`; export height=`stty size | cut -d " " -f1`-10; cat /tmp/data | sed "s/ /T/" | gnuplot -e "set terminal dumb $width $height; set autoscale; set xdata time; set timefmt \"%Y-%m-%dT%H:%M:%S\"; set xlabel \"time\"; set ylabel \"depth\"; plot '-' using 1:2 with lines"
export width=`stty size | cut -d " " -f2`; export height=`stty size | cut -d " " -f1`-10; cat /home/pi/data | sed "s/ /T/" | gnuplot -e "set terminal png ; set autoscale; set xdata time; set timefmt \"%Y-%m-%dT%H:%M:%S\"; set xlabel \"time\"; set ylabel \"depth\"; plot '-' using 1:2 with lines" | ~/.local/bin/imgcat
