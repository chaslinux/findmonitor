#!/bin/bash
# Bash script to detect monitor type and some basic specs
# by chaslinux@gmail.com
# Licensed under GPL v3

clear

sudo apt install ddcutil -y # to understand what ports are available
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

# Declare a bunch of variables to make life simpler later
CAPABILITIES=$(sudo ddcutil capabilities)
F60="Feature: 60"
FEATURE="Feature"
F60CAP=${CAPABILITIES#*$F60}
F60CAP=${F60CAP#*"(Input Source)"}
LIMFEATURE=${F60CAP%%$FEATURE*}
SERIAL=$(xrandr --verbose | edid-decode | grep "Product Serial Number:" | xargs | cut -c 32-)
MODEL=$(xrandr --verbose | edid-decode | grep "Product Name" | xargs | cut -c 23-)
LONGMFG=$(xrandr --verbose | edid-decode | grep "Manufacturer" | xargs | cut -c 14-)
SHORTMFG=$(echo $LONGMFG | cut -c -3 | xargs)
MANUFACTURER="I don't know this monitor"
RESOLUTION=$(xrandr | grep " connected" |sed -n -e 's/^.*connected //p' | xargs | awk '{print $1}')

# Determine the manufacturer by the Manufacturer Code $SHORTMFG
case $SHORTMFG in
	HWP)
		MANUFACTURER="HP"
		;;
	GSM)
		MANUFACTURER="LG"
		;;
	SAM)
		MANUFACTURER="Samsung"
		;;
	VSC)
		MANUFACTURER="ViewSonic"
		;;
	LEN)
		MANUFACTURER="Lenovo"
		;;
	VIT)
		MANUFACTURER="3M"
		;;
	DEL)
		MANUFACTURER="Dell"
		;;
	NEC)
		MANUFACTURER="NEC"
		;;
	ACI)
		MANUFACTURER="ASUS"
		;;
	AOC)
		MANUFACTURER="AOC"
		;;
	ACR)
		MANUFACTURER="Acer"
		;;
	BNQ)
		MANUFACTURER="BenQ"
		;;
	*)
		MANUFACTURER="I don't know this monitor"
		;;
esac

# temporarily delete monitor.tex before running script
rm /home/$USER/Desktop/monitor.tex

# Put the Serial number in a text file on the desktop
echo $SERIAL >> /home/$USER/Desktop/monserial.txt
barcode -e 128 -i /home/$USER/Desktop/monserial.txt  -o /home/$USER/Desktop/monserial.eps
epspdf /home/$USER/Desktop/monserial.eps /home/$USER/Desktop/monserial.pdf
pdfcrop --margins '0 10 10 0' /home/$USER/Desktop/monserial.pdf /home/$USER/Desktop/cropserial.pdf

#Set up the LaTeX document
if [ ! -f /home/$USER/Desktop/monitor.tex ]; then
	echo "creating /home/$USER/Desktop/monitor.tex"
	touch /home/$USER/Desktop/monitor.tex
	echo "\documentclass{article}" >> /home/$USER/Desktop/monitor.tex
	echo "\usepackage{blindtext}" >> /home/$USER/Desktop/monitor.tex
	echo "\usepackage{mdframed}" >> /home/$USER/Desktop/monitor.tex
#	echo "\usepackage[paperheight=4.0in,paperwidth=8.0in,margin=0.25in,heightrounded,showframe]{geometry}" >> /home/$USER/Desktop/monitor.tex
	echo "\usepackage{parskip}" >> /home/$USER/Desktop/monitor.tex
	echo "\usepackage{graphicx}" >> /home/$USER/Desktop/monitor.tex
	echo "\begin{document}" >> /home/$USER/Desktop/monitor.tex
fi
echo "\begin{table}" >> /home/$USER/Desktop/monitor.tex
echo "\begin{mdframed}" >> /home/$USER/Desktop/monitor.tex

echo "Manufacturer:" $MANUFACTURER  >> /home/$USER/Desktop/monitor.tex >> /home/$USER/Desktop/monitor.tex
echo "\newline" >> /home/$USER/Desktop/monitor.tex
echo "Model: " $MODEL >> /home/$USER/Desktop/monitor.tex
echo "\newline" >> /home/$USER/Desktop/monitor.tex
echo "Serial Number: " $SERIAL >> /home/$USER/Desktop/monitor.tex
echo "\newline" >> /home/$USER/Desktop/monitor.tex
echo "Resolution: " $RESOLUTION >> /home/$USER/Desktop/monitor.tex
echo "\newline" >> /home/$USER/Desktop/monitor.tex
echo "Inputs" $LIMFEATURE >> /home/$USER/Desktop/monitor.tex #Display Inputs
# xrandr --verbose | edid-decode | grep "Serial Number:" | cut -c 32- >> /home/$USER/Desktop/monitor.tex
echo "\includegraphics{cropserial.pdf}" >> /home/$USER/Desktop/monitor.tex
echo "\end{mdframed}" >> /home/$USER/Desktop/monitor.tex
echo "\end{table}" >> /home/$USER/Desktop/monitor.tex
echo "\end{document}"  >> /home/$USER/Desktop/monitor.tex
# This is so I can do a barcode later

# strip any underscores
cd /home/$USER/Desktop
sed -i s/\_//g monitor.tex
pdflatex monitor.tex
rm /home/$USER/Desktop/monitor.tex
rm /home/$USER/Desktop/monitor.log
rm /home/$USER/Desktop/monitor.aux
rm /home/$USER/Desktop/monserial.eps
rm /home/$USER/Desktop/monserial.pdf
rm /home/$USER/Desktop/monserial.txt
rm /home/$USER/Desktop/cropserial.pdf

