#!/bin/bash

mitm_path="/home/student/Group-1H-honeyj-rs/MITM/mitm/index.js"

sudo bash delete_honeypot.sh HRServeA 128.8.238.119 26 10000 $mitm_path
sudo bash delete_honeypot.sh HRServeB 128.8.238.86 26 10001 $mitm_path
sudo bash delete_honeypot.sh HRServeC 128.8.238.120 26 10002 $mitm_path
sudo bash delete_honeypot.sh HRServeD 128.8.37.125 27 10003 $mitm_path
