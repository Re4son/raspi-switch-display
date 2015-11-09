#!/bin/bash
##################################################################
## Name:	switch-display.sh                               ##
## Purpose:	switches raspberry pi 2 output between hdmi     ##
##              and pitft.                                      ##
##              requires that pitft is fully installed.         ##
## Author:	Re4son <re4son [at] whitedome.com.au>           ##
## TODO:        Adjust BASEDIR to match the location of this    ##
##              script (default: /home/pi/src/tft)              ##
##################################################################

##BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
## I'm hardcoding the location of this script to allow to place a link on my desktop
BASEDIR="/home/pi/src/tft"
FBTURBO="/usr/share/X11/xorg.conf.d/99-fbturbo.conf"

cd $BASEDIR

echo "[+] Determining current mode"
if [ -f $FBTURBO ];
    then
        echo "[*] HDMI mode detected"
        echo "[+] Backing up /usr/share/X11/xorg.conf.d/99-fbturbo.conf"
        if [ -f $BASEDIR/99-fbturbo.conf ];
            then
                sudo mv -f $BASEDIR/99-fbturbo.conf $BASEDIR/99-fbturbo.old
        fi

        echo "[+] Removing /usr/share/X11/xorg.conf.d/99-fbturbo.conf"
        sudo mv -f /usr/share/X11/xorg.conf.d/99-fbturbo.conf $BASEDIR

        echo "[+] Backing up /boot/cmdline.txt"
        if [ -f $BASEDIR/cmdline.txt ];
            then
                sudo mv -f $BASEDIR/cmdline.txt ./cmdline.old
        fi
        sudo cp -f /boot/cmdline.txt $BASEDIR

        echo "[+] Replacing /boot/cmdline.txt"
        sudo cp -f $BASEDIR/cmdline.pitft /boot/cmdline.txt

        echo "[*] Raspberry Pi will be in PiTFT mode after the next reboot."

    else
        echo "[*] PiTFT mode detected"

        echo "[+] Creating /usr/share/X11/xorg.conf.d/99-fbturbo.conf"
        sudo cp -f $BASEDIR/99-fbturbo.conf /usr/share/X11/xorg.conf.d/

        echo "[+] Backing up /boot/cmdline.txt"
        if [ -f $BASEDIR/cmdline.txt ];
            then
                sudo mv -f $BASEDIR/cmdline.txt $BASEDIR/cmdline.old
        fi
        sudo cp -f /boot/cmdline.txt $BASEDIR

        echo "[+] Replacing /boot/cmdline.txt"
        sudo cp -f $BASEDIR/cmdline.hdmi /boot/cmdline.txt

        echo "[*] Raspberry Pi will be in HDMI mode after the next reboot."
fi
        echo "[>] Please reboot for the changes to take effect"

