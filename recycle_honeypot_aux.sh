#!/bin/bash
# Auxiliary script to connect recycling script and the script that monitors for
# when to recycle a honeypot (when the attacker leave or after 3 hours)

# First check if proper number of shell arguments is given
if [ $# -ne 2 ]; then
  echo "usage: $0 <honeypot_name> <compress_data_flag>"
  exit 1
fi

honeypot=$(echo "$1" | sed 's/HRServe//')

if [ "$honeypot" == "A" ]; then
  sudo bash recycle_honeypot.sh HRServeA 128.8.238.119 26 10000 /home/student/active_data_A "$2" >> /home/student/honeypot_logs/A_lifecycle.log 2>&1
elif [ "$honeypot" == "B" ]; then 
  sudo bash recycle_honeypot.sh HRServeB 128.8.238.86 26 10001 /home/student/active_data_B "$2" >> /home/student/honeypot_logs/B_lifecycle.log 2>&1
elif [ "$honeypot" == "C" ]; then 
  sudo bash recycle_honeypot.sh HRServeC 128.8.238.120 26 10002 /home/student/active_data_C "$2" >> /home/student/honeypot_logs/C_lifecycle.log 2>&1
elif [ "$honeypot" == "D" ]; then 
  sudo bash recycle_honeypot.sh HRServeD 128.8.37.125 27 10003 /home/student/active_data_D "$2" >> /home/student/honeypot_logs/D_lifecycle.log 2>&1
else
  echo "Invalid honeypot name. Cannot recycle honeypot."
  exit 1
fi
