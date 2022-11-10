#!/bin/bash
# Bash script to detect monitor type and some basic specs
# by chaslinux@gmail.com
# Licensed under GPL v3

clear

if [ ! -f /usr/bin/edid-decode ]; then
	echo "*** Installing EDID ***"
	sudo apt update
	sudo apt install edid-decode -y
fi

LONGMFG=$(xrandr --verbose | edid-decode | grep "Manufacturer" | cut -c 15-)
SHORTMFG=$(echo $LONGMFG | cut -c -3)
xrandr --verbose | edid-decode | grep "Manufacturer" | cut -c 15-
xrandr --verbose | edid-decode | grep "Product Name"
xrandr --verbose | edid-decode | grep "Serial Number:"
xrandr | grep " connected" | cut -c 18-
case $SHORTMFG in
	HWP)
		echo -n "HP"
		;;
	GSM)
		echo -n "LG"
		;;
	SAM)
		echo -n "Samsung"
		;;
	VSC)
		echo -n "ViewSonic"
		;;
	LEN)
		echo -n "Lenovo"
		;;
	VIT)
		echo -n "3M"
		;;
	DEL)
		echo -n "Dell"
		;;
	NEC)
		echo -n "NEC"
		;;
	ACI)
		echo -n "ASUS"
		;;
	AOC)
		echo -n "AOC"
		;;
	ACR)
		echo -n "Acer"
		;;
	BNQ)
		echo -n "BenQ"
		;;
	*)
		echo "I don't know this monitor"
		;;
esac
echo -ne "\n"
# This is so I can do a barcode later
# xrandr --verbose | edid-decode | grep "Serial Number:" | cut -c 32-

