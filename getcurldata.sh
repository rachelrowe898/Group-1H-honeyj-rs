#!/bin/bash

while read line; do
  ip=$(cat $line | grep -B 1 Compromising | head -n 1 | awk '{ print $8 }')
  cmd=$(cat $line | grep curl | cut -d " " -f 5-)
  echo $line,${ip%,},\"$cmd\"
done <$1
