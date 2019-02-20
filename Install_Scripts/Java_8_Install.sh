#!/usr/bin/env bash
## Java 8 Installation Script
## Dakr-xv

## Get the link for latest Java download
JAVA_DOWNLOAD=$(curl -s https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html\
 | grep "macosx-x64.dm" | awk '{print $9}' | cut -f5 -d '"' | grep "8u202")

## Name of the DMG file that will be downloaded
JAVA_DMG=$(echo $JAVA_DOWNLOAD | cut -f9 -d'/')

## Version number of Java 8 that we will download
JAVA_VER=$(echo $JAVA_DMG | cut -f2 -d'-' | cut -f2 -d'u')

## Download the latest version of Java
curl -s -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie"\
 $JAVA_DOWNLOAD -o /tmp/$JAVA_DMG

## Mount the DMG
sudo hdiutil attach /tmp/$JAVA_DMG -nobrowse

## Install the PKG
sudo installer -pkg "/Volumes/Java 8 Update $JAVA_VER/Java 8 Update\
 $JAVA_VER.app/Contents/Resources/JavaAppletPlugin.pkg" -target /

## Get the Volume Name
JAVA_VOLUME=$(hdiutil info | grep "/Volumes/Java" | awk '{ print $3 " " $4 " " $5 " " $6}')

## Unmount the DMG
sudo hdiutil detach "$JAVA_VOLUME"

## Remove the DMG
rm -f /tmp/$JAVA_DMG
