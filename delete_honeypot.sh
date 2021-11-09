#!/bin/bash

# Script is used to delete compromised honeypot

# First check if proper number of shell arguments is given
if [ $# -ne 6 ]; then
  echo "usage: $0 <honeypot> <external_IP>\
 <netmask_prefix> <mitm_port> <mitm_path> <compress_data_flag>"
  exit 1
fi

honeypot=$1
external_ip=$2
netmask_prefix=$3
mitm_port=$4
mitm_path=$5
compress_data_flag=$6

honeypot_state=$(sudo lxc-info -n "${honeypot}" -sH)

echo "[$(date +"%F %H:%M:%S")] Deleting compromised honeypot ${honeypot}..."

###### Delete compromised honeypot

# Make sure honeypot is running so its IP can be accessed
echo "[$(date +"%F %H:%M:%S")] Checking honeypot state..."
if [[ $honeypot_state != "RUNNING" ]]; then
  sudo lxc-start -n "$honeypot"
  sleep 5
fi

echo "[$(date +"%F %H:%M:%S")] Deleting relevant iptables rules..."
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
echo "[$(date +"%F %H:%M:%S")] Deleting NAT mapping to compromised honeypot..."
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
# kill malware_monitoring.sh
sleep 5

dataJobNum=$(ps aux | grep "malware_monitoring.sh" | grep "$honeypot" | awk '{ print $2 }' | sed -n 1p)
while [ -n "$dataJobNum" ] ; do
  sudo kill -9 ${dataJobNum}
  dataJobNum=$(ps aux | grep "malware_monitoring.sh" | grep "$honeypot" | awk '{ print $2 }' | sed -n 1p)
done

# kill inotifywait processes specifically
dataJobNum=$(ps aux | grep "inotifywait" | grep "$honeypot" | awk '{ print $2 }' | sed -n 1p)
while [ -n "$dataJobNum" ] ; do
  sudo kill -9 ${dataJobNum}
  dataJobNum=$(ps aux | grep "inotifywait" | grep "$honeypot" | awk '{ print $2 }' | sed -n 1p)
done

echo "[$(date +"%F %H:%M:%S")] Malware monitoring stopped"

# Delete container
echo "[$(date +"%F %H:%M:%S")] Deleting container..."
honeypot_state=$(sudo lxc-info -n "${honeypot}" -sH)
if [[ $honeypot_state != "STOPPED" ]]; then
  sudo lxc-stop -n "$honeypot" -t 5
fi
sudo lxc-destroy -n "$honeypot"
sleep 5
echo "[$(date +"%F %H:%M:%S")] Compromised honeypot ${honeypot} deleted."


###### Delete running MITM processes
echo "[$(date +"%F %H:%M:%S")] Deleting MITM processes..."
process_to_delete1="sudo nohup node ${mitm_path} HACS200 ${mitm_port} \
${compromised_ip} ${honeypot} true mitm.js"
pid1=`ps aux | grep "${process_to_delete1}" | head -n 1 | awk '{print $2}'`
sudo kill -9 "$pid1"

process_to_delete2="node ${mitm_path} HACS200 ${mitm_port} \
${compromised_ip} ${honeypot} true mitm.js"
pid2=`ps aux | grep "${process_to_delete2}" | head -n 1 | awk '{print $2}'`
sudo kill -9 "$pid2"

echo "[$(date +"%F %H:%M:%S")] MITM processes deleted."

###### Compress and save collected data only if attacker successfully logged into honeypot
if [ "$compress_data_flag" == "1" ]; then
  echo "[$(date +"%F %H:%M:%S")] Compressing data..."
  container_code=${honeypot: -2:-1}
  attkID=$(cat "/home/student/attackerID/attackerID_$container_code.txt")
  sudo bash data_compression.sh "/home/student/active_data_$(($mitm_port - 10000))/" "/home/student/compressed_data/${container_code}/" "$container_code" "$attkID"
  echo $(( $attkID + 1 )) > "/home/student/attackerID/attackerID_${container_code}.txt"
  echo "[$(date +"%F %H:%M:%S")] Attacker data compressed and saved."
fi
