#!/bin/bash

# installs the following services specified to a started container
#
# wget
# curl
# ssh

if [ $# -ne 1 ]
then
  echo "usage: $0 <container_name>"
  exit 1
fi

# assumes container exist
sudo lxc-attach -n $1 -- apt-get install wget -y
sudo lxc-attach -n $1 -- apt-get install curl -y

sudo lxc-attach -n $1 -- apt-get install openssh-server -y

sudo lxc-attach -n $1 -- apt-get install man -y 
sudo lxc-attach -n $1 -- apt-get install zip -y 
