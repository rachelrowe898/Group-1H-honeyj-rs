#!/bin/bash
# Auxiliary script to connect recycling script and the script that monitors for
# when to recycle a honeypot (when the attacker leave or after 3 hours)

# First check if proper number of shell arguments is given
if [ $# -ne 1 ]; then
  echo "usage: $0 <honeypot_name>"
  exit 1
fi

honeypot=$(echo $1 | sed 's/HRServe//')

if [ "$honeypot" == "A" ]; then
  sudo bash recycle_honeypot.sh A 128.8.238.119 26 10000
elif [ "$honeypot" == "B" ]; then 
  sudo bash recycle_honeypot.sh B 128.8.238.86 26 10001
elif [ "$honeypot" == "C" ]; then 
  sudo bash recycle_honeypot.sh C 128.8.238.120 26 10002
elif [ "$honeypot" == "D" ]; then 
  sudo bash recycle_honeypot.sh D 128.8.37.125 27 10003
else
  echo "Invalid honeypot name. Cannot recycle honeypot."
  exit 1
fi
