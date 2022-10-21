#!/bin/bash
clear

if [ ! -f /usr/bin/edid-decode ]; then
	echo "*** Installing EDID ***"
	sudo apt update
	sudo apt install edid-decode -y
fi
xrandr --verbose | edid-decode | grep "Manufacturer" | cut -c 15-
xrandr --verbose | edid-decode | grep "Product Name"
xrandr --verbose | edid-decode | grep "Serial Number:"
xrandr | grep " connected" | cut -c 19-
# This is so I can do a barcode later
# xrandr --verbose | edid-decode | grep "Serial Number:" | cut -c 32-

