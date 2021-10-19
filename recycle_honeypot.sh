#!/bin/bash

# Script creates new honeypot from template container if the honeypot does not
# yet exist. If it does, then the script recycles the compromised honeypot and
# creates a new, clean honeypot.

# NOTE: Template containers should all end in "[name]_template" and the 
# created honeypot will be called "[name]"


# change back MITM config file after working on it 
# note: script to poison the wget and curl commands will 
# already be present in template containers
# note: Copying off malware from container to sandbox VM will be separate script

# First check if proper number of shell arguments is given
if [ $# -ne 4 ]; then
  echo "usage: $0 <container_to_recycle> <external_IP>\
 <netmask_prefix> <mitm_port> "
  exit 1
fi

honeypot=$1
template="$1_template"
external_ip=$2
netmask_prefix=$3
mitm_port=$4

mitm_path="/home/eric/MITM/mitm/index.js"

# ensure UMD network interface is up
sudo ip link set dev enp4s2 up

if [[ -z $(sudo lxc-ls --filter="^${honeypot}$") ]]; then
# If honeypot does not exist, create clean honeypot
  echo "Creating honeypot ${honeypot}..."
  sudo bash create_honeypot.sh "$honeypot" "$template" \
    "$external_ip" "$netmask_prefix" "$mitm_port" "$mitm_path"
else
  echo "Recycling existing honeypot ${honeypot}..."
# Else, recycle honeypot
  sudo bash delete_honeypot.sh "$honeypot" "$template" \
    "$external_ip" "$netmask_prefix" "$mitm_port" "$mitm_path"
  sudo bash create_honeypot.sh "$honeypot" "$template" \
    "$external_ip" "$netmask_prefix" "$mitm_port" "$mitm_path"
fi