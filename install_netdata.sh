!/bin/bash

if [ $# -ne 1 ]
then
  echo "call me with 1 arg, the name of the target container"
  exit 1
fi
sudo lxc-info -n "$1" > /dev/null 2>&1
if [ "$?" -eq 1 ]
then
  echo "$1 does not exist" ; exit 1
fi
sudo lxc-info -n "$1" | grep -q "RUNNING" > /dev/null 2>&1
if [ "$?" -eq 1 ]
then
  echo "container network check failed"
fi

CONTAINERNAME="$1"

sudo lxc-attach -n "$CONTAINERNAME" -- bash <(curl -Ss https://my-netdata.io/kickstart.sh) --claim-token Q4Sa20KtMHgyT4bKzVaGokSHObByfEG_qzPrhsSA78RMqq4c5xXsY5waKppDyq3Lc05QbtVhPq7NCToH-qRVhbplPbyB2Gs7solw57e2qrKoAyxfEW1hDGC-GoxNTu235fnFFuc --claim-rooms e18e828a-710a-4225-9dce-9c25640f565b --claim-url https://app.netdata.cloud
