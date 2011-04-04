#!/bin/bash

##Date
date=$(date '+%H:%M')

##Fonctions
# Reseau
# AddiKT1ve <the.addikt1ve@gmail.com>
# Mwyann <http://mwyann.info>
network() {
	# Variables
	ethiface=eth0
	#WLANIFACE=wlan0
	tmpdir=$HOME/.tmp_bak

	# Functions
	function rx_bytes { # download
	rxethernet=`cat /sys/class/net/$ethiface/statistics/rx_bytes`
#	RXWIRELESS=`cat /sys/class/net/$WLANIFACE/statistics/rx_bytes`
	echo $(($rxethernet))
	}

	function tx_bytes { # upload
	txethernet=`cat /sys/class/net/$ethiface/statistics/tx_bytes`
#	TXWIRELESS=`cat /sys/class/net/$WLANIFACE/statistics/tx_bytes`
	echo $(($txethernet))
	}

	# Download
	lastrxbytes=`cat $tmpdir/last_rxbytes`
	# Upload
	lasttxbytes=`cat $tmpdir/last_txbytes`

	# Download
	rxbytes=`rx_bytes`
	rxresult=$((($rxbytes-lastrxbytes)/1000))
	echo $rxbytes > $tmpdir/last_rxbytes
	# Upload
	txbytes=`tx_bytes`
	txresult=$((($txbytes-lasttxbytes)/1000))
	echo $txbytes > $tmpdir/last_txbytes

	echo "↓ $rxresult Ko/s - $txresult Ko/s ↑"
	}

mail() {
    gmail_login="Koubi4cK"  
    gmail_password="20031987" 
 
    dane=$(wget --secure-protocol=TLSv1 --timeout=3 -t 1 -q -O - \
        "https://${gmail_login}:${gmail_password}@mail.google.com/mail/feed/atom" \
        --no-check-certificate | sed -n '/fullcount/{s/.*<fullcount>//;s/<\/fullcount>.*//p}' 2>/dev/null) 
    
    if [[ ! $dane ]]; then
        echo 'Connection Error !'
    else
        echo " $dane"
    fi  
}

##Mpd progressbar et lecture en cours
mpdpos=$(sed -nr '/playing/{s/.*\(([[:digit:]]*).*\)/\1/p}' < <(mpc))
mpdbar=$(wmfs-status-gauge 1440 4 50 5 '#587aa4' 1 '#939393' "$mpdpos")
mpdsong=$(read -n 23 -r s < <(mpc current); echo "$s...")

if grep -q -e playing -e paused < <(mpc); then
    mpd="\i[1300;-1;16;16;/home/koub/.config/wmfs/img/music.png]\ \s[1315;10;#939393;$mpdsong $mpdbar]\\"
fi

wmfs -s 0 "$mpd \i[1495;-1;16;16;/home/koub/.config/wmfs/img/mail.png]\ \s[1505;10;#939393;$(mail)]\ \s[1525;10;#939393;$(network)]\ \i[1638;2;9;9;/home/koub/.config/wmfs/img/time.png]\ \s[1650;10;#939393;$date]\ "
