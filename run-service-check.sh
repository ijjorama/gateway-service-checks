#!/bin/bash
#
# Usage: run-gateway-service-check.sh host service
#

usage="Usage: $(basename $0) host <gridftp|xrootd>"

if [[ $# -ne 2 ]] ; then

  echo ${usage} >/dev/stderr;  exit 1

fi


export PATH

case $2 in 
  "gridftp")
    service=$2
    nagsvc="Ceph GridFTP functional test"
    ;;
  "xrootd")
    service=$2
    nagsvc="Ceph XRootD functional test"
    ;;
  *) 
    echo ${usage} >/dev/stderr; exit 1
    ;;

esac

host=$1

failed=/tmp/${service}-check-failed
succeeded=/tmp/${service}-check-succeeded
log=/var/log/gateway-check/${service}.log

start=$(date --rfc-3339=seconds) 

msg=$(/opt/service-checks/${service}-check.sh ${host})

#end=$(date --rfc-3339=seconds)
if [[ $? -ne 0 ]] ; then

  status=2

  end=$(date --rfc-3339=seconds)

  echo ${start} failed ${end} >> ${log}
  touch ${failed}; rm -f ${succeeded}

else 
  msg="All is well"
  status=0
  end=$(date --rfc-3339=seconds)
 
  echo ${start} succeeded ${end} >> ${log}
  touch ${succeeded}; rm -f ${failed}

fi

host=$(cut -d . -f 1 <<<${host})

echo -e "${host}\t${nagsvc}\t${status}\t${msg}\n" | 
send_nsca -H nagger.gridpp.rl.ac.uk -c /etc/nagios/send_nsca.cfg 
