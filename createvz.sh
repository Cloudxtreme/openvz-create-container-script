#!/bin/bash
VZUID="$1"
VZHOSTNAME="$2"
VZIP="$3"
VZTEMPLATE="$4"
if [[ $1 != "" && $2 != "" && $3 != "" && $4 != "" ]]; then
  # Create an OpenVz container
  /usr/sbin/vzctl create $VZUID --ostemplate $VZTEMPLATE --config basic
  # Set the OpenVz container to boot with the machine
  /usr/sbin/vzctl set $VZUID --onboot yes --save
  # Set the hostname and the ip address
  /usr/sbin/vzctl set $VZUID --hostname $VZHOSTNAME --save
  /usr/sbin/vzctl set $VZUID --ipadd $VZIP --save
  # Set the number of Sockets and the NameServers
  /usr/sbin/vzctl set $VZUID --numothersock 360 --save
  /usr/sbin/vzctl set $VZUID --nameserver 4.2.2.2 --save
  /usr/sbin/vzctl set $VZUID --nameserver 8.8.8.8 --save
  /usr/sbin/vzctl set $VZUID --nameserver 8.8.4.4 --save
  # Set the privvmpages is your memory limit.
  /usr/sbin/vzctl set $VZUID --vmguarpages $((256 * 512)) --save  # 512MB   Dedicated (Guaranteed)
  /usr/sbin/vzctl set $VZUID --privvmpages $((256 * 1024)) --save # 1024MB  Burst     (Granted)
  # Set NFS option on
  /usr/sbin/vzctl set $VZUID --features "nfs:on" --save
  # Set Harddisk space
  /usr/sbin/vzctl set $VZUID --diskspace 3G:4G --save
  # Sync date/time from host to container
  /usr/sbin/vzctl set $VZUID --capability sys_time:on --save
  # Start the container
  /usr/sbin/vzctl start $VZUID
  echo ""
  /usr/sbin/vzlist -a
else
  /bin/echo ""
  /bin/echo "./create_vz.sh <UID> <HOSTNAME> <IP> <TEMPLATE>"
  /bin/echo ""
  /bin/echo ""
  /usr/sbin/vzlist -a
fi
