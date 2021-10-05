#!/bin/bash

if [ $# -eq 0 ]; then
  echo "usage: $0 <template identifier>"
  exit 1
fi

lines=0

if [ "$1" == 'A' ]; then
  lines=0
elif [ $"$1" == 'B' ]; then
  lines=5000
elif [ "$1" == 'C' ]; then
  lines=50000
elif [ "$1" == 'D' ]; then
  lines=500000
else
  echo "invalid template identiifier (must be A, B, C, or D)"
  exit 2
fi

name="$1_template"

sudo lxc-create -n "$name" -t download -- -d ubuntu -r focal -a amd64
sudo lxc-start -n "$name"

path="/var/lib/lxc/$name/rootfs"

sudo lxc-attach -n "$name" -- mkdir shared
python3 honey-creation.py $lines
sudo mv employee-data.csv "$path/shared"

sudo lxc-attach -n "$name" -- apt-get install openssh-server -y

