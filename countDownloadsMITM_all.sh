#!/bin/bash

if [ $# -ne 3 ]
then
  echo "Usage: $0 <directory of unzip/> <recording file path> <download command>"
  exit 1
fi

dirUnzip=$1
recordFile=$2
downloadCmd=$3

maxIDA=$(ls ${dirUnzip} | grep A | wc -l)
echo "read A to $maxIDA"
maxIDB=$(ls ${dirUnzip} | grep B | wc -l)
echo "read B to $maxIDB"
maxIDC=$(ls ${dirUnzip} | grep C | wc -l)
echo "read C to $maxIDC"
maxIDD=$(ls ${dirUnzip} | grep D | wc -l)
echo " read D to $maxIDD"


bash countDownloadsMITM.sh $dirUnzip A $recordFile $downloadCmd $maxIDA
bash countDownloadsMITM.sh $dirUnzip B $recordFile $downloadCmd $maxIDB
bash countDownloadsMITM.sh $dirUnzip C $recordFile $downloadCmd $maxIDC
bash countDownloadsMITM.sh $dirUnzip D $recordFile $downloadCmd $maxIDD
