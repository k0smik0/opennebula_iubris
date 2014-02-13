#!/bin/bash

# Mount context variables
if [ -f /mnt/context.sh ]; then
   . /mnt/context.sh

   # fix ip issues
   IP_TO_DEL=$(ip addr show dev eth0 | grep -w inet | egrep -e " 0\." | awk '{print $2}' | cut -d":" -f2)
   [ ! -z $IP_TO_DEL ] && ip addr del $IP_TO_DEL dev eth0
   ip addr show dev eth0 | grep "10.19" >/dev/null || ifup --force eth0

	# Configure hostname
	if [ -n "${HOSTNAME_BASE}" ]; then
      last_bit=$(ip addr| grep "10\.19\.19" | awk '{print $2}' | cut -d"/" -f1 | awk -F"." '{print $4}')
	   echo ${HOSTNAME_BASE}${last_bit} > /etc/hostname
   elif [ -n "${HOSTNAME_VMID}" ]; then
	   echo ${HOSTNAME_VMID} > /etc/hostname
	fi
   hostname -F /etc/hostname
	
	# Configure DNS Nameservers
	if [ -n "$DNS" ]; then
	   echo "" > /etc/resolv.conf
	   for ns in $DNS; do
         echo "nameserver $ns" >> /etc/resolv.conf
      done
	fi

#   modprobe -r processor button thermal_sys \
#      iptable_filter ip6table_filter \
#      snd_pcsp snd_pcm \
#      drm_kms_helper ttm \
#      psmouse \
#      crc16 jbd2 mbcache ata_generic i2c_piix4 sg
fi
