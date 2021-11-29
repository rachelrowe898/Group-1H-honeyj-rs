#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage: $0 <./compressed_data to unzip/> <./unzip file destination/>"
  exit 1
fi

bash unzip_data.sh "$1" "$2" A
bash unzip_data.sh "$1" "$2" B
bash unzip_data.sh "$1" "$2" C
bash unzip_data.sh "$1" "$2" D
