#!/bin/bash

set -e

source settings.cnf

INTERFACE=$1
MAC_REGEX='([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
IP_REGEX='\b([0-9]{1,3}\.){3}[0-9]{1,3}\b'

if [ ! "$1" ]; then
  echo "ERROR: Missing interface argument."
  echo "E.g. ./net_guard en0"
  exit 1
fi


function should_alert(){
  # $1: mac address found
  # $2: whitelist filename to check against
  # $3: new_found filename to check against

  retval_alert=0
  if ! grep -q "$1" "$2"
  then
    if ! grep -q "$1" "$3"
    then
      retval_alert=1
    fi
  fi
}


function alert(){
  # $1: msg prefix for subject email
  # $2: mac address found
  # $3: new_found filename to register

  msg="\"$1 $2\""
  echo $msg
  cat ${CRT_FILE} | mail -s "$msg" ${ALERT_EMAIL_ADD}
  echo "$2" >> "$3"

}

function arp_full_scan(){
  arp-scan --interface=${INTERFACE} --localnet > ${CRT_FILE}
}

function prom_mode(){
  ips=" "
  cat ${CRT_FILE} | grep -oE ${IP_REGEX} $1 |
  {
    while read ip;
    do 
      ips="$ips $ip"
    done
    arp-scan --interface=${INTERFACE} --destaddr=01:00:5e:00:00:05 $ips | grep -oE ${MAC_REGEX} $1 | while read mac;
    do
      should_alert $mac ${P_WL_FILE} ${P_NF_FILE}
      if [ "$retval_alert" == 1 ]; then alert "Device on promiscuous mode found:" ${mac} ${P_NF_FILE} ;fi
    done
  }
}

function new_devices(){

  cat ${CRT_FILE} | grep -oE ${MAC_REGEX} $1 | while read mac;
  do 
    should_alert $mac ${WL_FILE} ${NF_FILE}
     if [ "$retval_alert" == 1 ]; then alert "New device found:" ${mac} ${NF_FILE} ;fi
  done

}


while :
do
  echo "Press [CTRL+C] to stop.."	
  arp_full_scan
  new_devices
  prom_mode
  sleep ${CHECK_INTERVAL}

done


