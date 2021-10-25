#!/bin/bash

# Script creates new honeypot from template container if the honeypot does not
# yet exist. If it does, then the script recycles the compromised honeypot and
# creates a new, clean honeypot.

# NOTE: Template containers should all end in "[name]_template" and the 
# created honeypot will be called "[name]"

# First check if proper number of shell arguments is given
if [ $# -ne 5 ]; then
  echo "usage: $0 <container_to_recycle> <external_IP>\
 <netmask_prefix> <mitm_port> <mitm_log_path>"
  exit 1
fi

honeypot=$1
template="$1_template"
external_ip=$2
netmask_prefix=$3
mitm_port=$4
mitm_log_path=$5

# Manually specify MITM path
mitm_path="/home/student/Group-1H-honeyj-rs/MITM/mitm/index.js"

# ensure UMD network interface is up
sudo ip link set dev enp4s2 up

echo -n "\n[$(date +"%F %H:%M:%S")] "
if [[ -z $(sudo lxc-ls --filter="^${honeypot}$") ]]; then
# If honeypot does not exist, create clean honeypot
  echo "Creating honeypot ${honeypot}..."
  sudo bash create_honeypot.sh "$honeypot" "$template" \
    "$external_ip" "$netmask_prefix" "$mitm_port" "$mitm_path" "$mitm_log_path"
else
  echo "Recycling existing honeypot ${honeypot}..."
# Else, recycle honeypot
  sudo bash delete_honeypot.sh "$honeypot" \
    "$external_ip" "$netmask_prefix" "$mitm_port" "$mitm_path"
  sudo bash create_honeypot.sh "$honeypot" "$template" \
    "$external_ip" "$netmask_prefix" "$mitm_port" "$mitm_path" "$mitm_log_path"
fi
