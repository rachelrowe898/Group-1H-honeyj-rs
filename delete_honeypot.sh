#!/bin/bash

# Script is used to delete compromised honeypot

# NOTE: kill tail -f processes before killing container

# First check if proper number of shell arguments is given
if [ $# -ne 6 ]; then
  echo "usage: $0 <honeypot> <template> <external_IP>\ 
 <netmask_prefix> <mitm_port> <mitm_path>"
  exit 1
fi

honeypot=$1
template=$2
external_ip=$3
netmask_prefix=$4
mitm_port=$5
mitm_path=$6

honeypot_state=$(sudo lxc-info -n "${honeypot}" -sH)

echo "Deleting compromised honeypot ${honeypot}..."

###### Delete compromised honeypot

# Make sure honeypot is running so its IP can be accessed
echo "Checking honeypot state..."
if [[ $honeypot_state != "RUNNING" ]]; then
  sudo lxc-start -n "$honeypot"
  sleep 5
fi

echo "Deleting relevant iptables rules..."
host_ip=$(hostname -I | awk '{print $1}')
sudo iptables --table nat \
              --delete PREROUTING \
              --source 0.0.0.0/0 \
              --destination "$external_ip" \
              --protocol tcp \
              --dport 22 \
              --jump DNAT \
              --to-destination "${host_ip}:${mitm_port}"

# Delete NAT mapping and external IP
echo "Deleting NAT mapping to compromised honeypot..."
compromised_ip="$(sudo lxc-info -n "${honeypot}" -iH)"
sudo iptables --table nat \
              --delete PREROUTING \
              --source 0.0.0.0/0 \
              --destination "${external_ip}" \
              --jump DNAT \
              --to-destination "${compromised_ip}"
sudo iptables --table nat \
              --delete POSTROUTING \
              --source "${compromised_ip}" \
              --destination 0.0.0.0/0 \
              --jump SNAT \
              --to-source "${external_ip}"
sudo ip addr delete "${external_ip}/${netmask_prefix}" dev enp4s2

# Stop data collection background processes
dataJobNum=$(jobs | grep "malware_monitoring.sh" | cut -d"]" -f1 | cut -d"[" -f2)
kill %$dataJobNum
echo "Malware monitoring stopped"

# Delete container
echo "Deleting container..."
if [[ $honeypot_state != "STOPPED" ]]; then
  sudo lxc-stop -n $honeypot
fi
sudo lxc-destroy -n $honeypot
sleep 5
echo "Compromised honeypot ${honeypot} deleted."


###### Delete running MITM processes
echo "Deleting MITM processes..."
process_to_delete1="sudo nohup node ${mitm_path} HACS200 ${mitm_port} \
${compromised_ip} ${honeypot} true mitm.js"
pid1=`ps aux | grep "${process_to_delete1}" | head -n 1 | awk '{print $2}'`
sudo kill -9 $pid1

process_to_delete2="node ${mitm_path} HACS200 ${mitm_port} \
${compromised_ip} ${honeypot} true mitm.js"
pid2=`ps aux | grep "${process_to_delete2}" | head -n 1 | awk '{print $2}'`
sudo kill -9 $pid2

echo "MITM processes deleted."

