#!/bin/bash

if [ $# -lt 1 ]; then
    echo "usage: $0 <container name>"
    exit 1
fi

p="/var/lib/lxc/$1/rootfs"

sudo inotifywait -m "$p/home" -e create |
    while read dir action file; do
        # echo "The file '$file' appeared in directory '$dir' via '$action'"
        if [ "$action" = "CREATE,ISDIR" ]; then
            sudo lxc-attach -n "$1" -- ln -s "/shared/" "/home/$file"
        fi
    done
