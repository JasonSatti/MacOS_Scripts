#!/usr/bin/env bash
## Java 11 Installation Script
## Jason Satti

## Download URL
JAVA_DOWNLOAD="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_osx-x64_bin.tar.gz"

## Name of the file that will be downloaded
JAVA=$(echo $JAVA_DOWNLOAD | cut -f9 -d'/')

## Download the latest version of Google Chrome into /tmp/
curl -s $JAVA_DOWNLOAD -o /tmp/$JAVA

## Copy contents of the Google Chrome DMG file to /Applications/
tar -xf /tmp/$JAVA -C /Library/Java/JavaVirtualMachines/

## Remove the DMG
rm -f /tmp/$JAVA
