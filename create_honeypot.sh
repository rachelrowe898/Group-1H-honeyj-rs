#!/bin/bash

# Script is used to create a new clean honeypot from a template container

# First check if proper number of shell arguments is given
if [ $# -ne 7 ]; then
  echo "usage: $0 <honeypot_name> <template_name> <external_IP>\ 
 <netmask_prefix> <mitm_port> <mitm_path> <mitm_log_path>"
  exit 1
fi

honeypot=$1
template=$2
external_ip=$3
netmask_prefix=$4
mitm_port=$5
mitm_path=$6
mitm_log_path=$7

template_state=`sudo lxc-ls -f | grep "${template}" | awk '{print $2}' | xargs`

echo "Creating clean honeypot ${honeypot}..."

###### Create new clean honeypot from template

# Check to see if template container is stopped so a copy can be created
if [[ $template_state != "STOPPED" ]]; then
  echo "Template container $template is not stopped or does not exist"
  exit 1
fi

# Check if destination container name is not already taken
if [[ -n $(sudo lxc-ls --filter="^${honeypot}$") ]]; then
  echo "Error: Destination container $honeypot already exists"
  exit 1
fi

# Perform copy operation and start container again
echo "Copying template..."
sudo lxc-copy -n "$template" -N "$honeypot"
sudo lxc-start -n "$honeypot"
sleep 5 # allow enough time for the IP mapping to be configured
echo "Copy container $template to $honeypot completed at $(date -Iseconds)"


###### Set up firewall rules and networking container rules on new container

# obtain newly created honeypot's internal IP address
clean_ip=$(sudo lxc-info -n "$honeypot" -iH)

# create NAT mapping for honeypot's IP to the specified external IP and netmask
echo "Configuring NAT mappings for clean honeypot..."
sudo ip addr add "${external_ip}/${netmask_prefix}" dev enp4s2
sudo iptables --table nat \
              --insert PREROUTING \
              --source 0.0.0.0/0 \
              --destination "${external_ip}" \
              --jump DNAT \
              --to-destination "${clean_ip}"
sudo iptables --table nat \
              --insert POSTROUTING \
              --source "${clean_ip}" \
              --destination 0.0.0.0/0 \
              --jump SNAT \
              --to-source "${external_ip}"

###### Set up MITM after external IP has been assigned

# launch MITM server in background mode
echo "Setting up MITM..."
# sudo nohup node [full path to ./mitm/index.js] [id] [port] [container_ip] \
# [container_id] [auto-access true/false] [mitm config name] > mitm_file 2>&1 &

mitm_log="${mitm_log_path}/${honeypot}.log"

sudo nohup node "$mitm_path" HACS200 "$mitm_port" \
  "$clean_ip" "$honeypot" true "mitm.js" > "$mitm_log" 2>&1 &


# Note: Container given as argument is assumed to already have openssh-server 
# installed on it and is already running

# insert relevant iptables rules for the external IP
echo "Inserting relevant iptables rules..."
host_ip=$(hostname -I | awk '{print $1}')
sudo iptables --table nat \
             --insert PREROUTING \
             --source 0.0.0.0/0 \
              --destination "$external_ip" \
             --protocol tcp \
              --dport 22 \
              --jump DNAT \
              --to-destination "${host_ip}:${mitm_port}"



# Restart data collection and monitoring
sudo bash monitor-mitm.sh "$mitm_log" "$external_ip"

# Restart data collection 
container_code=${honeypot: -1}
sudo bash malware_monitoring.sh "$honeypot" "/home/student/active_data_$container_code" "$container_code" &

echo "Finished recycling honeypot ${honeypot}."

