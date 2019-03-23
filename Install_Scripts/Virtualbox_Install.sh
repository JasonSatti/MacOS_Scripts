#!/usr/bin/env bash
## VirtualBox Installation Script
## Jason Satti

## Get the link for latest Virtualbox download
VIRTUALBOX_DOWNLOAD=$(curl -s -L https://www.virtualbox.org/wiki/Downloads |\
 grep "OS X hosts" | awk '{print $3}' | cut -f2 -d'"')

## Name of the DMG file that will be downloaded
VIRTUALBOX_DMG=$(echo $VIRTUALBOX_DOWNLOAD | cut -f6 -d"/")

## Download the latest version of Virtualbox
curl -s $VIRTUALBOX_DOWNLOAD -o /tmp/$VIRTUALBOX_DMG

## Mount the DMG
sudo hdiutil attach $VIRTUALBOX_DMG

## Install the PKG
sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target /

## Unmount the DMG
sudo hdiutil detach /Volumes/VirtualBox

## Remove the DMG
sudo rm /tmp/$VIRTUALBOX_DMG
