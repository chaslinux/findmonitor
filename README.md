# findmonitor.sh
# by chaslinux, chaslinux-at-gmail.com
# Licenses under GPL v3

This script is intended to be used by people who have to process a bunch of monitors in a short time.
It has been tested on Xubuntu 20.04 with a few dozen monitors, but there are many manufacturers I may not
have covered. It is intended only for desktop monitors, not laptops or televisions. It is tested on
Xubuntu 20.04 and 22.04, but may work on other Debian-based systems.

This script uses EDID: https://en.wikipedia.org/wiki/Extended_Display_Identification_Data and DDC: 
https://en.wikipedia.org/wiki/Display_Data_Channel to grab information about a monitor and produce 
a LaTeX file, which is converted to a PDF.

Because it's dependent on EDID and DCC, some of the information may be inaccurate as Manufacturers
do not always fill out these fields, or fill them out in an unexpected fashion.

When the script is working 100% the PDF will show:
* manufacturer name
* model
* serial number
* resolution
* inputs (for example: VGA, DisplayPort, DVI, HDMI)
* a barcode with a serial number

The PDF this script produces is a letter-sized PDF with a small rectangle in the middle including 
the items above. We cut off the top and bottom pieces and use the scrap for phone messages at our
computer refurbishing project.

# Running the script
To run the script, change into the findmonitor directory and run:
./findmonitor.sh

You will be prompted for the sudo (super user do) password. The sudo password is needed to query the
monitor's capabilities.

# Notes about testing
Our testing process was conducted by plugging many different displays into the DVI port of a
small computer. We've recently updated the script to support plugging into VGA and HDMI, but have 
noticed some unusual results.

# Manufacturers we recognize
Our project has monitors from the following manufacturers, so I've included support for these in the
script:
* 3M
* Acer
* AOC
* ASUS
* BenQ
* Dell
* HP
* Lenovo
* LG
* NEC
* Samsung
* ViewSonic

I realize there are manu more manufacturers out there. See below for how you can help fill out the script
if you have a monitor from another manufacturer.

# I don't know this monitor (result)
If your monitor is not detected, or you run into strange results, please run the following and email
me the monitor.txt result to the email address at the top of this file.

xrandr --verbose | edid-decode > /home/$USER/Desktop/monitor.txt

It would also be handy to have the result of:

sudo ddcutil capabilities

in an email, but because ddcutil needs sudo access if you redirect it to a file you may need to change
the permissions to your current user account.

This is a work in progress, and evolves as we run into issues at our project.
