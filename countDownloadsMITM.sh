#!/bin/bash

if [ $# -ne 5 ]
then
  echo "Usage: $0 <directory of unzip/> <container code> <recording file path> <download command> <Max attack ID>"
  exit 1
fi

unzippedDir="$1"
container_code="$2"
recordFile="$3"
downloadCmd="$4 " #add space at end
maxID="$5"
attk_ID=1
count=0

parentDir=${unzippedDir}${container_code}_${attk_ID}
while [ $attk_ID -le $maxID ] ; do
  active_data_name=$(ls ${unzippedDir}${container_code}_${attk_ID})

  if [ "$active_data_name" != "" ]
  then
    subDir=${unzippedDir}${container_code}_${attk_ID}/${active_data_name}
    hrserve=$(ls ${subDir}/HRServe${container_code}*)

    if [ $hrserve != "" ]
    then
      # absoluteHRServe=${subDir}/${hrserve}
      grepResult="$(grep ${downloadCmd} ${hrserve})"
      if [[ ! -z "${grepResult}" ]]
      then
        echo "added a line for $hrserve"
        echo ${hrserve} >> ${recordFile}
      fi
    fi
  fi
  # update var for next:
  attk_ID=$(( $attk_ID + 1 ))

  parentDir=${unzippedDir}${container_code}_${attk_ID}
done

attk_ID=$(( $attk_ID - 1 ))
echo "Last read: ${container_code}_${attk_ID}"
