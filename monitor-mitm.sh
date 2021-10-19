#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: $0 <mitm log file>"
    exit 1
fi

start="0"

sudo tail -f "$1" | while read line; do
    if [[ "$line" == *"Attacker authenticated and is inside container"* ]]; then
        start=$(echo "$line" | cut -d ' ' -f 1-2 | sed 's/ /T/')
    elif [[ $line == *"Cleaning up..."* ]]; then
        bash recycle_honeypot.sh
    else
        curr=$(echo "$line" | cut -d ' ' -f 1-2 | sed 's/ /T/')

        if [ $(( $(date -d "$curr" +%s) - $(date -d "$start" +%s) )) -ge 10800 ]; then
            # kick attacker out
            bash recycle_honeypot.sh
        fi
    fi
done
