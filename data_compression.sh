#!/bin/bash

# compresses all data files in a directory for a honeypot attack
# and moves these compressed into another directory
# else where


if [ $# -ne 4 ]
then
  echo "Usage: $0
      <file path to directory with />
      <compressed files dest path with />
      <honeypot code>
      <attackerID>"
  exit 1
fi

if [ -d "$1" ]
then
  destdir="$3_$4$(date +_%m_%d)" #Zipped directory naming: [containerID]_[attackerID]_MM_DD.zip
  cd "$2"
  zip -r "$destdir" "$1"

  rm -r $1
  mkdir $1
fi
