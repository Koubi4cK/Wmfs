#!/bin/bash

##Date
DATE=`date '+%H:%M'`

##Reseau
NETWORK=`/home/koub/.config/wmfs/netstat.sh
`
wmfs -s 0 "$NETWORK \\i[1000;0;16;16;~/.config/wmfs/conf.d/img/tags/quicktime.npg]\\$DATE"
