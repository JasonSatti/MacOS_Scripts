#!/usr/bin/env bash
## RingCentral Installation Script
## Dakr-xv

## Get the link for latest RingCentral download
RINGCENTRAL_DOWNLOAD=$(curl https://success.ringcentral.com/RCSupportPortalDownloads | grep "Download for MAC" | grep "RCMeetingsClientSetup" | awk '{print $3}' | cut -f2 -d'"')

## Name of the PKG file that will be downloaded
RINGCENTRAL_PKG=$(echo $RINGCENTRAL_DOWNLOAD | cut -f9 -d'/')

## Download the latest version of RingCentral
curl -O $RINGCENTRAL_DOWNLOAD

## Install the PKG
sudo installer -package RCMeetingsClientSetup.pkg -target /

## Remove the PKG file
sudo rm $RINGCENTRAL_PKG

