#!/usr/bin/env bash
## VirtualBox Update Script  
## Dakr-xv

## Get the latest VirtualBox version from their website
LATEST_VIRTUALBOX_VERSION=$(curl -s https://www.virtualbox.org/wiki/Downloads |\
 grep "platform packages" | awk '{ print $5 }')

## Get the current Virtualbox version installed on the device
CURRENT_VIRTUALBOX_VERSION=$(virtualbox --help |\
 grep "Oracle VM VirtualBox Manager" | awk '{print $5}') 

## Compare the current virtualbox version to the latest version on the website
## Download and install if the version is not up to date
if [ "$CURRENT_VIRTUALBOX_VERSION" = "$LATEST_VIRTUALBOX_VERSION" ]; then
  echo "Virtualbox up to date."
  exit 0
else
  echo "Virtualbox update available."
fi

## Get the link for latest Virtualbox download
VIRTUALBOX_DOWNLOAD=$(curl -s -L https://www.virtualbox.org/wiki/Downloads |\
 grep "OS X hosts" | awk '{print $3}' | cut -f2 -d'"' | cut -f1 -d'"')

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
