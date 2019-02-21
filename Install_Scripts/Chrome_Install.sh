#!/usr/bin/env bash
## Google Chrome Installation Script
## Dakr-xv

## Link to download the latest Google Chrome
CHROME_DOWNLOAD="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"

## Name of the DMG file that will be downloaded
CHROME_DMG=$(echo $CHROME_DOWNLOAD | cut -f8 -d'/')

## Download the latest version of Google Chrome into /tmp/
curl -s $CHROME_DOWNLOAD -o /tmp/$CHROME_DMG

## Mount the DMG
hdiutil attach /tmp/$CHROME_DMG -nobrowse

## Copy contents of the Google Chrome DMG file to /Applications/
cp -pPR /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/

## Get the Volume Name
CHROME_VOLUME=$(hdiutil info | grep "/Volumes/Google Chrome" | awk '{ print $1 }')

## Unmount the Volume
hdiutil detach $CHROME_VOLUME

## Remove the DMG
rm -f /tmp/$CHROME_DMG
