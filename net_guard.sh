#!/bin/bash

set -e

source settings.cnf

INTERFACE=$1

if [ ! "$1" ]; then
  echo "ERROR: Missing interface argument."
  echo "E.g. ./net_guard en0"
  exit 1
fi


function process(){
  arp-scan --interface=${INTERFACE} --localnet > ${CRT_FILE}

  cat ${CRT_FILE} | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' $1 | while read x;
  do 
    if grep -Fxq "$x" ${WL_FILE}
    then
      :
    else
      if ! grep -Fxq "$x" ${NFL_FILE}
      then
        echo "new mac found: " $x
        cat ${CRT_FILE} | mail -s "New Device Found: ${x}" ${ALERT_EMAIL_ADD}
        echo "$x" >> new_found.txt
      fi
    fi
  done

}


while :
do
  echo "Press [CTRL+C] to stop.."	
  process 
  sleep ${CHECK_INTERVAL}
done


