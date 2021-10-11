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
  echo "invalid template identifier (must be A, B, C, or D)"
  exit 2
fi

name="$1_template"

sudo DOWNLOAD_KEYSERVER="keyserver.ubuntu.com" lxc-create -n "$name" -t download -- -d ubuntu -r focal -a amd64
sudo lxc-start -n "$name"

p="/var/lib/lxc/$name/rootfs"

sudo lxc-attach -n "$name" -- mkdir shared
python3 honey-creation.py $lines
sudo mv employee-data.csv "$p/shared"

sudo lxc-attach -n "$name" -- apt-get install openssh-server -y

for file in $(sudo ls "$p/etc/update-motd.d/"); do 
  sudo chmod a-x "$p/etc/update-motd.d/$file"
done 

motd="01-company"

sudo cp "$motd" "$p/etc/update-motd.d/"
sudo chmod u+x "$p/etc/update-motd.d/$motd"
