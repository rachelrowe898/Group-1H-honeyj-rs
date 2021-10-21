#!/bin/bash
#send the zip file from data account on host to data account on workstation

scp /home/data/*\.zip data@172.30.137.116:/home/data/backedup_data/

rm /home/data/*\.zip
