#!/bin/bash

# Execute with sudo
# makes a hidden directory on container to store downloaded file malware
# alters curl and wget commands to always copy malware file into hidden
# directory

download_dir="/var/log/.downloads" #if modify here must modify below

if [ $# -ne 1 ]
then
  echo "Usage: $0 <container_name>"
  exit 1
fi

#assumes container exists, assumes curl and wget are installed from install services


#create hidden download directory
mkdir /var/lib/lxc/"$1"/rootfs$download_dir
chmod g+w-r /var/lib/lxc/"$1"/rootfs$download_dir
chmod o+w-r /var/lib/lxc/"$1"/rootfs$download_dir

#wget configuration:
mv /var/lib/lxc/"$1"/rootfs/usr/bin/wget /var/lib/lxc/"$1"/rootfs/usr/bin/wget0
echo '#!/bin/bash' > /var/lib/lxc/"$1"/rootfs/usr/bin/wget
echo 'wget0 $@ -O /var/log/.downloads/$(date +%s) -q > /dev/null 2>&1' >> \
   /var/lib/lxc/"$1"/rootfs/usr/bin/wget
echo 'wget0 $@' >> /var/lib/lxc/"$1"/rootfs/usr/bin/wget
chmod g+x /var/lib/lxc/"$1"/rootfs/usr/bin/wget
chmod o+x /var/lib/lxc/"$1"/rootfs/usr/bin/wget

#curl configuration:
mv /var/lib/lxc/"$1"/rootfs/usr/bin/curl /var/lib/lxc/"$1"/rootfs/usr/bin/curl0
echo '#!/bin/bash' > /var/lib/lxc/"$1"/rootfs/usr/bin/curl
echo 'curl0 -o /var/log/.downloads/$(date +%s) $@ -s > /dev/null 2>&1' >> \
    /var/lib/lxc/"$1"/rootfs/usr/bin/curl
echo 'curl0 $@' >> /var/lib/lxc/"$1"/rootfs/usr/bin/curl
chmod g+x /var/lib/lxc/"$1"/rootfs/usr/bin/curl
chmod o+x /var/lib/lxc/"$1"/rootfs/usr/bin/curl
