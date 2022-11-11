#!/bin/bash
# Bash script to detect monitor type and some basic specs
# by chaslinux@gmail.com
# Licensed under GPL v3

clear

sudo apt install texlive-latex-extra -y
sudo apt -y install texlive-latex-base # to make pdfs
sudo apt -y install barcode # to create barcodes
sudo apt -y install texlive-extra-utils # So we can create convert eps barcode to pdf then crop
sudo apt -y install texlive-pictures # more barcode handling

# check to see if edid-decode package is installed, if not, install it.
if [ ! -f /usr/bin/edid-decode ]; then
	echo "*** Installing EDID ***"
	sudo apt update
	sudo apt install edid-decode -y
fi

# temporarily delete monitor.tex before running script
rm /home/$USER/Desktop/monitor.tex

if [ ! -f /home/$USER/Desktop/monitor.tex ]; then
	echo "creating /home/$USER/Desktop/monitor.tex"
	touch /home/$USER/Desktop/monitor.tex
	echo "\documentclass{article}" >> /home/$USER/Desktop/monitor.tex
	echo "\usepackage{blindtext}" >> /home/$USER/Desktop/monitor.tex
	echo "\usepackage[paperheight=4.0in,paperwidth=8.0in,margin=0.25in,heightrounded,showframe]{geometry}" >> /home/$USER/Desktop/monitor.tex
	echo "\begin{document}" >> /home/$USER/Desktop/monitor.tex
fi

LONGMFG=$(xrandr --verbose | edid-decode | grep "Manufacturer" | cut -c 19-)
SHORTMFG=$(echo $LONGMFG | cut -c -3)
xrandr --verbose | edid-decode | grep "Manufacturer" | cut -c 5- >> /home/$USER/Desktop/monitor.tex
echo "\newline" >> /home/$USER/Desktop/monitor.tex
xrandr --verbose | edid-decode | grep "Product Name" >> /home/$USER/Desktop/monitor.tex
echo "\newline" >> /home/$USER/Desktop/monitor.tex
xrandr --verbose | edid-decode | grep "Serial Number:" >> /home/$USER/Desktop/monitor.tex
echo "\newline" >> /home/$USER/Desktop/monitor.tex
xrandr | grep " connected" | cut -c 18-  >> /home/$USER/Desktop/monitor.tex
echo "\newline" >> /home/$USER/Desktop/monitor.tex
case $SHORTMFG in
	HWP)
		echo -n "HP"  >> /home/$USER/Desktop/monitor.tex
		;;
	GSM)
		echo -n "LG"  >> /home/$USER/Desktop/monitor.tex
		;;
	SAM)
		echo -n "Samsung" >> /home/$USER/Desktop/monitor.tex
		;;
	VSC)
		echo -n "ViewSonic" >> /home/$USER/Desktop/monitor.tex
		;;
	LEN)
		echo -n "Lenovo" >> /home/$USER/Desktop/monitor.tex
		;;
	VIT)
		echo -n "3M" >> /home/$USER/Desktop/monitor.tex
		;;
	DEL)
		echo -n "Dell" >> /home/$USER/Desktop/monitor.tex
		;;
	NEC)
		echo -n "NEC" >> /home/$USER/Desktop/monitor.tex
		;;
	ACI)
		echo -n "ASUS" >> /home/$USER/Desktop/monitor.tex
		;;
	AOC)
		echo -n "AOC" >> /home/$USER/Desktop/monitor.tex
		;;
	ACR)
		echo -n "Acer" >> /home/$USER/Desktop/monitor.tex
		;;
	BNQ)
		echo -n "BenQ" >> /home/$USER/Desktop/monitor.tex
		;;
	*)
		echo "I don't know this monitor" >> /home/$USER/Desktop/monitor.tex
		;;
esac
echo -ne "\n"  >> /home/$USER/Desktop/monitor.tex
# xrandr --verbose | edid-decode | grep "Serial Number:" | cut -c 32- >> /home/$USER/Desktop/monitor.tex
echo "\end{document}"  >> /home/$USER/Desktop/monitor.tex
# This is so I can do a barcode later

# strip any underscores
cd /home/$USER/Desktop
sed -i s/\_//g monitor.tex
pdflatex monitor.tex


