#!/bin/bash

#takes in a compressed_data folder and unzips all data files for a specified container
#code into a central directory. All data will be placed into a subdirectory in the
#format [container code]_[attack ID]

if [ $# -ne 3 ]
then
  echo "Usage: $0 <./compressed_data to unzip/> <./unzip file destination/> <container code>"
  exit 1
fi

zipSourceDir="$1"
extractedDest="$2"

attackID="1"
containerCode="$3"

# get zip file name
currUnzip=$( ls "$zipSourceDir$containerCode" | grep "${containerCode}_${attackID}_" )
currUnzip="$zipSourceDir$containerCode/$currUnzip"

if [[ "$currUnzip" != "$zipSourceDir$containerCode/" ]]
then
  fileExists=1
 #echo "above file path exists"
else
  fileExists=0
fi

while [ $fileExists -eq 1 ] ; do
  #create the subdirectory to unzip to
  subDestDir="$extractedDest${containerCode}_${attackID}"
  echo "sending dest dir: $subDestDir"
  mkdir "$subDestDir"
  unzip "$currUnzip" -d "$subDestDir"

#prep next unzip
  attackID=$(( $attackID + 1 ))
 #echo "ls on ${zipSourceDir}${containerCode}"
 #echo "grep on ${containerCode}_${attackID}"

  currUnzip=$(ls "${zipSourceDir}${containerCode}" | grep "${containerCode}_${attackID}_")
  currUnzip="$zipSourceDir$containerCode/$currUnzip"

 #echo "file path to unzip $currUnzip"

  if [[ "$currUnzip" != "$zipSourceDir$containerCode/" ]]
  then
    fileExists=1
   #echo "above file path exists"
  else
    fileExists=0
  fi

done

attackID=$(( $attackID - 1 ))
echo "last unzipped: ${containerCode}, ${attackID}"
