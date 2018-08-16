#!/usr/bin/env bash
## VirtualBox Installation Script
## Dakr-xv

## Get the logged in user
LOGGED_IN_USER=`/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys;\
 username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]];\
 sys.stdout.write(username + "\n");'`
 
## Get the link for latest Virtualbox download
VIRTUALBOX_DOWNLOAD=$(curl -L https://www.virtualbox.org/wiki/Downloads | grep "OS X hosts" | awk '{print $3}' | cut -f2 -d'"')

## Name of the DMG file that will be downloaded
VIRTUALBOX_DMG=$(echo $VIRTUALBOX_DOWNLOAD | cut -f6 -d"/")

## Download the latest version of Virtualbox
curl -O $VIRTUALBOX_DOWNLOAD

## Mount the DMG
sudo hdiutil attach $VIRTUALBOX_DMG

## Install the PKG
sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target /

## Unmount the DMG
sudo hdiutil detach /Volumes/VirtualBox

## Remove the DMG
sudo rm $VIRTUALBOX_DMG