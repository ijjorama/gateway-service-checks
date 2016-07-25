#!/bin/bash

#
# Usage: run-gateway-service-check.sh host service
#

usage="Usage: $(basename $0) host <gridftp|xrootd>"

if [[ $# -ne 2 ]] ; then

  echo ${usage} >/dev/stderr;  exit 1

fi


case $2 in 
  "gridftp")
    service = "gridftp"
    ;;
  "xrootd")
    service = "xrootd"
    ;;
  *) 
    echo ${usage} >/dev/stderr; exit 1
    ;;

esac

host=$1

failed=/tmp/${service}-check-failed
succeeded=/tmp/${service}-check-succeeded


/opt/service-checks/${service}-check.sh $(hostname)

if [[ $? -ne 0 ]] ; then

  touch ${failed}; rm -f ${succeeded}

else 
 
  touch ${succeeded}; rm -f ${failed}

fi

