#!/bin/bash

# compresses all data files in a directory for a honeypot attack
# and moves these compressed into another directory
# else where


if [ $# -ne 5 ]
then
  echo "Usage: $0
      <file path to directory with />
      <compressed files dest path with />
      <honeypot code>
      <attackerID>
      <mitm port - 10000>"
  exit 1
fi



if [ -d "$1" ]
then
  zipname="$3_$4$(date +_%m_%d)" #Zipped directory naming: [containerID]_[attackerID]_MM_DD.zip
  cd "/home/student"
  localPath="active_data_$5"
  zip -r "$zipname" "$localPath"
  mv "$zipname.zip" "$2"
fi
