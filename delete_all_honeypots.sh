#!/bin/bash
# Delete all containers without compressing any data

mitm_path="/home/student/Group-1H-honeyj-rs/MITM/mitm/index.js"

sudo bash delete_honeypot.sh "$(sudo lxc-ls -1 | grep 0)" 128.8.238.119 26 10000 "$mitm_path" 0
sudo bash delete_honeypot.sh "$(sudo lxc-ls -1 | grep 1)" 128.8.238.86 26 10001 "$mitm_path" 0
sudo bash delete_honeypot.sh "$(sudo lxc-ls -1 | grep 2)" 128.8.238.120 26 10002 "$mitm_path" 0
sudo bash delete_honeypot.sh "$(sudo lxc-ls -1 | grep 3)" 128.8.37.125 27 10003 "$mitm_path" 0
