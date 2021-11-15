#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: $0 <mitm log file> <mitm port>"
  exit 1
fi

mitm_log_file=$1
mitm_port=$2
container=$(echo "$mitm_log_file" | cut -d '/' -f 5 | sed 's/.log//')
rules_added=0

host_ip=$(hostname -I | awk '{print $1}')
valid_data=1
entered=0

echo "[$(date +"%F %H:%M:%S")] Monitoring file $mitm_log_file on port $mitm_port"

while read line; do
  if [[ $rules_added -eq 0 && "$line" == *"Attacker connected"* ]]; then
    # stores last seen IP address in the MITM log
    attacker_ip=$(echo "$line" | awk '{ print $8 }')
  elif [[ "$line" == *"Adding the following credentials"* ]]; then
    # Add symbolic link to new user account created by MITM
    user=$(echo "$line" | awk '{ print $11 }' | sed 's/\"//g' | cut -d ":" -f 1)
    sleep 1
    sudo lxc-attach -n "$container" -- ln -s "/shared/" "/home/$user/"
  elif [[ $rules_added -eq 0 && "$line" == *"Attacker authenticated and is inside container"* ]]; then
    echo "[$(date +"%F %H:%M:%S")] Starting timer and adding IP blocking rules"
    bash timer.sh "$mitm_log_file" "$attacker_ip" "$host_ip" "$mitm_port" &
    # Add networking rules to keep out all traffic except the attacker IP that is already inside
    rules_added=1
    entered=1
    sudo iptables -A INPUT -s "$attacker_ip" -d "$host_ip" -p tcp --destination-port "$mitm_port" -j ACCEPT
    sudo iptables -A INPUT -d "$host_ip" -p tcp --destination-port "$mitm_port" -j REJECT
  elif [[ "$line" == *"Attacker closed connection"* ]]; then
    ps -aux | grep "tail -f $1" | awk '{ print $2 }' | sed '$ d' | sudo xargs kill
    break
  elif [[ $entered -eq 0 && "$line" == *"Invalid credentials"* ]]; then 
    # force recycling but w/o saving data -- this means we have a problem 
    valid_data=0
    ps -aux | grep "tail -f $1" | awk '{ print $2 }' | sed '$ d' | sudo xargs kill
  fi
done < <(sudo tail -f "$1")

if [ "$valid_data" -eq 1 ]; then 
  echo "[$(date +"%F %H:%M:%S")] Killing timer and removing IP blocking rules" 
  # kill timer command
  ps -aux | grep "timer.sh $1" | awk '{ print $2 }' | sed '$ d' | xargs kill

  # After attacker leaves, reset networking rules and recycle container
  sudo iptables -D INPUT -s "$attacker_ip" -d "$host_ip" -p tcp --destination-port "$mitm_port" -j ACCEPT
  sudo iptables -D INPUT -d "$host_ip" -p tcp --destination-port "$mitm_port" -j REJECT
fi 

echo "[$(date +"%F %H:%M:%S")] Calling recycling script from monitor-mitm"
sudo bash recycle_honeypot_aux.sh "$container" "$mitm_port" "$valid_data"
