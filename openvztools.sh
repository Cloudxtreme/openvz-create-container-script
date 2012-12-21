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

######################
# Path
#
PATH_DIR="/usr/sbin"

##########################################
# Funtions to automate the creation and 
# the management of the OpenVZ containers
# 
function create_vz {
    NUMBERARGS=$#
    VZUID="$1"
    VZHOSTNAME="$2"
    VZIP="$3"
    
    if [[ $NUMBERARGS == 4 ]]; then
        VZTEMPLATE="$4"
    fi
    
    if [[ $NUMBERARGS == 5 ]]; then
        VZMEMGARANTEED="$4"
        VZTEMPLATE="$5"
    fi
    
    if [[ $NUMBERARGS == 6 ]]; then
        VZMEMGARANTEED="$4"
        VZMEMGRANTED="$5"
        VZTEMPLATE="$6"
    fi    
    
    ###################
    # Main loop
    # 
    if [[ $VZUID != "" && $VZHOSTNAME != "" && $VZIP != "" && $VZTEMPLATE != "" ]]; then
        # Create an OpenVz container
        $PATH_DIR/vzctl create $VZUID --ostemplate $VZTEMPLATE --config basic
        # Set the OpenVz container to boot with the machine
        $PATH_DIR/vzctl set $VZUID --onboot yes --save
        # Set the hostname and the ip address
        $PATH_DIR/vzctl set $VZUID --hostname $VZHOSTNAME --save
        $PATH_DIR/vzctl set $VZUID --ipadd $VZIP --save
        # Set the number of Sockets and the NameServers
        $PATH_DIR/vzctl set $VZUID --numothersock 360 --save
        # Set default DNS server
        if [[ $DEFAULT_NAMESERVER != "" ]]; then
            $PATH_DIR/vzctl set $VZUID --nameserver $DEFAULT_NAMESERVER --save
        else
            $PATH_DIR/vzctl set $VZUID --nameserver 8.8.8.8 --save
        fi        
        # Set the privvmpages is your memory limit..
        # Guaranteed memory
        if [[ $VZMEMGARANTEED != "" ]]; then
            $PATH_DIR/vzctl set $VZUID --vmguarpages $((256 * $VZMEMGARANTEED)) --save  # xxxMB   Dedicated (Guaranteed)
        else
            $PATH_DIR/vzctl set $VZUID --vmguarpages $((256 * 512)) --save  # 512MB   Dedicated (Guaranteed)
        fi
	# Memory for the Out of Memory barrier
	if [[ $VZMEMGARANTEED != "" ]]; then
            $PATH_DIR/vzctl set $VZUID --oomguarpages $((256 * $VZMEMGARANTEED)) --save  # xxxMB   Dedicated (Guaranteed)
        else
            $PATH_DIR/vzctl set $VZUID --oomguarpages $((256 * 512)) --save  # 512MB   Dedicated (Guaranteed)
        fi
        # Granted memory
        if [[ $VZMEMGRANTED != "" ]]; then
            $PATH_DIR/vzctl set $VZUID --privvmpages $((256 * $VZMEMGRANTED)) --save # xxxxMB  Burstable     (Granted)
        else
            $PATH_DIR/vzctl set $VZUID --privvmpages $((256 * 1024)) --save # 1024MB  Burstable     (Granted)
        fi        
        # Set NFS option on
        $PATH_DIR/vzctl set $VZUID --features "nfs:on" --save
        # Set Harddisk space
        $PATH_DIR/vzctl set $VZUID --diskspace 3G:4G --save
        # Sync date/time from host to container
        $PATH_DIR/vzctl set $VZUID --capability sys_time:on --save
        # Start the container
        $PATH_DIR/vzctl start $VZUID
        echo ""
        $PATH_DIR/vzlist -a
    else
        /bin/echo ""
        /bin/echo "Usage: "
        /bin/echo "vzcreate <UID> <HOSTNAME> <IP> <TEMPLATE>"
        /bin/echo ""
        /bin/echo ""
        $PATH_DIR/vzlist -a
    fi
}


function destroy_container {
    for id in $@; do
        $PATH_DIR/vzctl stop $id;
        $PATH_DIR/vzctl destroy $id;
    done
}


function onboot_vz_container {
    for id in $@; do
        $PATH_DIR/vzctl set $id --onboot yes --save;
    done
}


function offboot_vz_container {
    for id in $@; do
        $PATH_DIR/vzctl set $id --onboot no --save;
    done
}


function stop_vz {
    for id in $@; do
        $PATH_DIR/vzctl stop $id;
    done
}


function start_vz {
    for id in $@; do
        $PATH_DIR/vzctl start $id;
    done
}


function restart_vz {
    for id in $@; do
        $PATH_DIR/vzctl restart $id;
    done
}


function add_dns {
    VZUID=($@:0)
    NUMARGS=($@)
    NAMESERVERS=${NUMARGS[@]:1}
    if [[ $# -ge 2 ]]; then
        for ips in $NAMESERVERS; do
            $PATH_DIR/vzctl set $VZUID --nameserver $ips --save
        done
    else
        echo "Usage:    vzadddns <UID> <nameserver>"
    fi
}


function change_hostname {
    VZUID="$1"
    VZHOSTNAME="$2"
    if [[ $# -eq 2 ]]; then
        $PATH_DIR/vzctl set $VZUID --hostname $VZHOSTNAME --save
    else
        echo "Usage:    vzhostname <UID> <hostname>"
    fi
}

function vzcreatedump {
    for id in $@; do
        $PATH_DIR/vzctl stop $id;
        $PATH_DIR/vzdump --bwlimit 1024 $id;
        $PATH_DIR/vzctl start $id;
    done
}

########################################## 
# Alias to call the function defined above
#
alias vzlist="vzlist -a"
alias vzenter="vzctl enter "
alias vzstop="stop_vz "
alias vzstart="start_vz "
alias vzrestart="restart_vz "
alias vzdestroy="destroy_container "
alias vzcreate="create_vz "
alias vzonboot="onboot_vz_container "
alias vzoffboot="offboot_vz_container "
alias vzadddns="add_dns "
alias vzhostname="change_hostname "
alias vzcreatedump="vzcreatedump "

