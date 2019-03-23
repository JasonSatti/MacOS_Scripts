#!/usr/bin/env bash
## Slack Installation Script
## Jason Satti

## Get the link for latest Slack download
DOWNLOAD_URL="https://slack.com/ssb/download-osx"
SLACK_DOWNLOAD=$(curl "$DOWNLOAD_URL" -s -L -I -o /dev/null -w '%{url_effective}')

## Name of the DMG file that will be downloaded
SLACK_DMG=$(echo $SLACK_DOWNLOAD | cut -f5 -d'/')

## Download the latest version of Slack into /tmp/
curl -s $SLACK_DOWNLOAD -o /tmp/$SLACK_DMG

## Mount the DMG
hdiutil attach /tmp/$SLACK_DMG -nobrowse

## Copy contents of the Slack DMG file to /Applications/
cp -pPR /Volumes/Slack*/Slack.app /Applications

## Get the Volume Name
SLACK_VOLUME=$(diskutil list | grep Slack | awk '{ print $3 }')

## Unmount the Volume
diskutil eject $SLACK_VOLUME

## Remove the DMG
rm -f /tmp/$SLACK_DMG
