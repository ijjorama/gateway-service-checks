#!/bin/sh

if [[ $# -ne 1 ]] ; then
  echo Usage: $0 hostname
  exit 1
fi
#set -x

host=$1

.  /etc/sysconfig/gateway-service-check

grid-proxy-init -valid 0:10  2>&1 >>/tmp/$$.log 2>&1  || { tr '\n' '\t' < /tmp/$$.log ;  exit 1; }

globus-url-copy  file://${source}  gsiftp://${host}/${target} >/tmp/$$.log 2>&1  || 
{ echo Transfer INTO ${host} failed >> /tmp/$$.log; tr '\n' '\t' < /tmp/$$.log ;   exit 1; } 

#globus-url-copy gsiftp://${host}/${target} file:////nodir  ||  

globus-url-copy gsiftp://${host}/${target} file://${fileback}  2>/tmp/$$.log  || 
{ echo Transfer BACK from ${host} failed >> /tmp/$$.log; tr '\n' '\t' < /tmp/$$.log; exit 1; }

cmp ${source}  ${fileback} || { echo Source file and retrieved file are not the same >/dev/stderr; exit 1; }
rm -f ${fileback} /tmp/$$.log

