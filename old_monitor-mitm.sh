#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: $0 <mitm log file>"
    exit 1
fi

container=$(echo "$1" | sed 's/.log//')
start="0"

while read line; do
    if [[ "$line" == *"Attacker connected"* ]]; then 
        ip=$(echo "$line" | awk '{ print $8 }')
    elif [[ "$line" == *"Attacker authenticated and is inside container"* ]]; then
        start=$(echo "$line" | cut -d ' ' -f 1-2 | sed 's/ /T/')
    elif [[ $line == *"Attacker closed connection"* ]]; then
        sudo kill $(ps -aux | grep "sudo tail -f $1" | awk '{ print $2 }' | head -n 1)
        break
    else
        curr=$(echo "$line" | cut -d ' ' -f 1-2 | sed 's/ /T/')

        if [ $(( $(date -d "$curr" +%s) - $(date -d "$start" +%s) )) -ge 10800 ]; then
            sudo kill $(ps -aux | grep "sudo tail -f $1" | awk '{ print $2 }' | head -n 1)
            break
        fi
    fi
done < <(sudo tail -f "$1")

echo $ip
bash recycle_honeypot_aux.sh "$container"

