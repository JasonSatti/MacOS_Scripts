#!/usr/bin/env bash
## Java Installation Script
## Dakr-xv

## Get the link for latest Java download
JAVA_DOWNLOAD=$(curl -s https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html | grep "macosx-x64.dm" | awk '{print $9}' | cut -f5 -d '"')

## Name of the DMG file that will be downloaded
JAVA_DMG=$(echo $JAVA_DOWNLOAD | cut -f9 -d'/')

## Version number of Java 8 that we will download
JAVA_VER=$(echo $JAVA_DMG | cut -f2 -d'-' | cut -f2 -d'u')

## Download the latest version of Java
curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_DOWNLOAD > $JAVA_DMG

## Mount the DMG
sudo hdiutil attach $JAVA_DMG -nobrowse

## Install the PKG
sudo installer -pkg "/Volumes/Java 8 Update $JAVA_VER/Java 8 Update $JAVA_VER.app/Contents/Resources/JavaAppletPlugin.pkg" -target /

## Unmount the DMG
sudo hdiutil detach "/Volumes/Java 8 Update $JAVA_VER"

## Remove the DMG
sudo rm $JAVA_DMG
