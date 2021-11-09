#!/bin/bash
# Run script on restart using crontab

if [ $# -gt 1 ]; then
  echo "usage: $0 <optional: compress_data_flag>"
  exit 1
fi

# default is to compress data after recycling
compress_data_flag=${1:-1}

if [ "$compress_data_flag" != "1" ] && [ "$compress_data_flag" != "0" ]; then
  echo "Invalid argument for <compress_data_flag>: $compress_data_flag"
  echo "Please input either 0 or 1 for <compress_data_flag>"
  exit 1
fi

sudo bash recycle_honeypot_aux.sh $(sudo lxc-ls -1 | grep 0 || echo "NO_CONTAINER") 10000 "$compress_data_flag"
sudo bash recycle_honeypot_aux.sh $(sudo lxc-ls -1 | grep 1 || echo "NO_CONTAINER") 10001 "$compress_data_flag"
sudo bash recycle_honeypot_aux.sh $(sudo lxc-ls -1 | grep 2 || echo "NO_CONTAINER") 10002 "$compress_data_flag"
sudo bash recycle_honeypot_aux.sh $(sudo lxc-ls -1 | grep 3 || echo "NO_CONTAINER") 10003 "$compress_data_flag"
