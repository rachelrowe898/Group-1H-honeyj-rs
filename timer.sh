#!/bin/bash

if [ $# -ne 4 ]; then
  echo "usage: $0 <mitm log file path> <attacker_ip> <host_ip> <mitm port>"
  exit 1
fi

container=$(echo "$1" | cut -d '/' -f 5 | sed 's/.log//')
attacker_ip="$2"
host_ip="$3"
mitm_port="$4"

sleep 10800

echo "[$(date +"%F %H:%M:%S")] Killing monitoring script and removing IP blocking rules"
# murder monitoring script
ps -aux | grep "monitor-mitm.sh $1" |  awk '{ print $2 }' | sed '$ d' | xargs kill

# end stuff
sudo iptables -D INPUT -s "$attacker_ip" -d "$host_ip" -p tcp --destination-port "$mitm_port" -j ACCEPT

sleep 600

sudo iptables -D INPUT -d "$host_ip" -p tcp --destination-port "$mitm_port" -j REJECT

echo "[$(date +"%F %H:%M:%S")] Calling recycling script from timer"
sudo bash recycle_honeypot_aux.sh "$container" "$mitm_port" 1
