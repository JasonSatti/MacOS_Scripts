#!/usr/bin/env bash
## Google Chrome Installation Script
## Dakr-xv

## Name of the DMG file that will be downloaded
GOOGLE_DMG="googlechrome.dmg"

## Download the latest version of Google Chrome into /tmp/
curl -s https://dl.google.com/chrome/mac/stable/GGRO/$GOOGLE_DMG -o /tmp/$GOOGLE_DMG

## Mount the DMG
hdiutil attach /tmp/$GOOGLE_DMG -nobrowse

## Copy contents of the Google Chrome DMG file to /Applications/
cp -pPR /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/

## Get the Volume Name
CHROME_VOLUME="$(hdiutil info | grep "/Volumes/Google Chrome" | awk '{ print $1 }')"

## Unmount the Volume
hdiutil detach $CHROME_VOLUME

## Remove the DMG
rm -f /tmp/$GOOGLE_DMG
