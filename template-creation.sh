#!/bin/bash

if [ $# -eq 0 ]; then
  echo "usage: $0 <template identifier>"
  exit 1
fi

lines=0

if [ "$1" == 'A' ]; then
  lines=0
elif [ "$1" == 'B' ]; then
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

# this is for making the shared folder
sudo lxc-attach -n "$name" -- mkdir shared
python3 honey-creation.py $lines
sudo mv employee-data.csv "$p/shared"

# adding fake users + symlinks
sudo lxc-attach -n "$name" -- ln -s "/shared/" "/home/ubuntu"
for user in admin hbrown orange rli194 peterjp aj14 mrobinson kels dranna william bkrds umichaels rye panr ohara ellapatterson cnjr mrsamson kailee florence; do
  pass=$(echo $RANDOM | base64 | head -c 20; echo)
  echo -e "$pass\n$pass" | sudo lxc-attach -n "$name" -- adduser "$user" 
  sudo lxc-attach -n "$name" -- ln -s "/shared/" "/home/$user"
done 

# this is for updating the ssh banner
sudo lxc-attach -n "$name" -- apt-get update
bash install_services.sh "$name"
sudo bash poison_commands.sh "$name"

for file in $(sudo ls "$p/etc/update-motd.d/"); do 
  sudo chmod a-x "$p/etc/update-motd.d/$file"
done 

motd="01-company"

sudo cp "$motd" "$p/etc/update-motd.d/"
sudo chmod u+x "$p/etc/update-motd.d/$motd"

sudo lxc-stop -n "$name"
