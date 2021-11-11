#!/bin/bash
# Auxiliary script to connect recycling script and the script that monitors for
# when to recycle a honeypot (when the attacker leave or after 3 hours)

# First check if proper number of shell arguments is given
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "usage: $0 <honeypot_name> <mitm_port> <optional: compress_data_flag>"
  exit 1
fi

honeypot=$1
mitm_port=$2

# compress data only if compress_data_flag is set to 1
# default is to compress data after recycling
compress_data_flag=${3:-1}

if [ "$compress_data_flag" != "1" ] && [ "$compress_data_flag" != "0" ]; then
  echo "Invalid argument for <compress_data_flag>: $compress_data_flag"
  echo "Please input either 0 or 1 for <compress_data_flag>"
  exit 1
fi

if [ "$mitm_port" == "10000" ]; then
  sudo bash recycle_honeypot.sh "$honeypot" 128.8.238.119 26 10000 /home/student/active_data_0 "$compress_data_flag" >> /home/student/honeypot_logs/0_lifecycle.log 2>&1
elif [ "$mitm_port" == "10001" ]; then 
  sudo bash recycle_honeypot.sh "$honeypot" 128.8.238.86 26 10001 /home/student/active_data_1 "$compress_data_flag" >> /home/student/honeypot_logs/1_lifecycle.log 2>&1
elif [ "$mitm_port" == "10002" ]; then 
  sudo bash recycle_honeypot.sh "$honeypot" 128.8.238.120 26 10002 /home/student/active_data_2 "$compress_data_flag" >> /home/student/honeypot_logs/2_lifecycle.log 2>&1
elif [ "$mitm_port" == "10003" ]; then 
  sudo bash recycle_honeypot.sh "$honeypot" 128.8.37.125 27 10003 /home/student/active_data_3 "$compress_data_flag" >> /home/student/honeypot_logs/3_lifecycle.log 2>&1
else
  echo "Invalid MITM Port. Cannot recycle honeypot. Please input either 10000, 10001, 10002, 10003."
  exit 1
fi
