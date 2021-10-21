#!/bin/bash

# execute as a cron task to send data files to
# data account on host

if [ $# -ne 2 ]
then
  #creates a zip file in the same directory as the source
  echo "Usage $0 <directoryNameToZip> <directoryPath/>"
  exit 1
fi

cd $2

#create zip
zipname=$(date +%m%d_%H:%M:%S_backup)
zip -r "$zipname" "$1"
sudo mv "$zipname.zip" /home/data/
