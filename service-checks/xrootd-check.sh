#!/bin/sh

if [[ $# -ne 1 ]] ; then
  echo Usage: $0 hostname
  exit 1
fi

host=$1
echo Before: $PATH
.  /etc/sysconfig/gateway-service-check
echo After: $PATH
/usr/bin/grid-proxy-init -valid 0:10 >/dev/null


xrdcp --silent --force  file:///${source}  root://${host}//${target} || { echo Transfer IN failed;  exit 1; } 

xrdcp --silent --force  root://${host}//${target} file:///${fileback}  || { echo Transfer BACK failed; exit 1; }

cmp ${source}  ${fileback} || { echo Source file and retrieved file are not the same >/dev/stderr; exit 1; }
rm -f ${fileback} 
