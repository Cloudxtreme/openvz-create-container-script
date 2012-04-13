#!/bin/bash
#
# This file is part of openvz-create-container-script ( https://github.com/drivard/openvz-create-container-script ).
#
# Copyright (C) 2011 Dominick Rivard <dominick.rivard@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# OpenVZ Bash Alias Shortcuts
#
function create_vz {
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
    /bin/echo "Usage: "
    /bin/echo "vzcreate <UID> <HOSTNAME> <IP> <TEMPLATE>"
    /bin/echo ""
    /bin/echo ""
    /usr/sbin/vzlist -a
  fi
}
function destroy_container {
  for id in $@; do
    vzctl stop $id;
    vzctl destroy $id;
  done
}
function onboot_vz_container {
  for id in $@; do
    vzctl set $id --onboot yes --save;
  done
}
function offboot_vz_container {
  for id in $@; do
    vzctl set $id --onboot no --save;
  done
}
function stop_vz {
  for id in $@; do
    vzctl stop $id;
  done
}
function start_vz {
  for id in $@; do
    vzctl start $id;
  done
}
function restart_vz {
  for id in $@; do
    vzctl restart $id;
  done
}
alias vzlist="vzlist -a"
alias vzenter="vzctl enter "
alias vzstop="stop_vz "
alias vzstart="start_vz "
alias vzrestart="restart_vz "
alias vzdestroy="destroy_container "
alias vzcreate="create_vz "
alias vzonboot="onboot_vz_container "
alias vzoffboot="offboot_vz_container "
