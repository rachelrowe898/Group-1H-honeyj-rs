#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: $0 <mitm log file> <honeypot_public_ip>"
  exit 1
fi

mitm_log_file=$1
honeypot_public_ip=$2
container=$(echo "$mitm_log_file" | cut -d '/' -f 5 | sed 's/.log//')
start_time="0"

while read line; do
  if [[ "$line" == *"Attacker connected"* ]]; then
    # stores last seen IP address in the MITM log
    attacker_ip=$(echo "$line" | awk '{ print $8 }')
  elif [[ "$line" == *"Adding the following credentials"* ]]; then 
    # Add symbolic link to new user account created by MITM
    user=$(echo $line | awk '{ print $11 }' | sed 's/\"//g' | cut -d ":" -f 1)
    sudo lxc-attach -n "$container" -- ln -s "/shared/" "/home/$user"
  elif [[ "$line" == *"Attacker authenticated and is inside container"* ]]; then
    start_time=$(echo "$line" | cut -d ' ' -f 1-2 | sed 's/ /T/')
    # Add networking rules to keep out all traffic except the attacker IP that is already inside
    sudo iptables --append INPUT --source "$attacker_ip" --destination "$honeypot_public_ip" --protocol tcp --jump ACCEPT
    sudo iptables --append INPUT --destination "$honeypot_public_ip" --jump DROP
  elif [[ "$line" == *"Attacker closed connection"* ]]; then
    sudo kill "$(ps -aux | grep "sudo tail -f $1" | awk '{ print $2 }' | head -n 1)"
    break
  elif [[ "$start" != "0" ]]; then
    curr_time=$(echo "$line" | cut -d ' ' -f 1-2 | sed 's/ /T/')
    # Force honeypot reset if attacker does not leave after 3 hours
    if [ $(( $(date -d "$curr_time" +%s) - $(date -d "$start_time" +%s) )) -ge 10800 ]; then
      sudo kill "$(ps -aux | grep "sudo tail -f $1" | awk '{ print $2 }' | head -n 1)"
      break
    fi
  fi
done < <(sudo tail -f "$1")

# After attacker leaves, reset networking rules and recycle container
sudo iptables --delete INPUT --source "$attacker_ip" --destination "$honeypot_public_ip" --protocol tcp --jump ACCEPT
sudo iptables --delete INPUT --destination "$honeypot_public_ip" --jump DROP
sudo bash recycle_honeypot_aux.sh "$container"
