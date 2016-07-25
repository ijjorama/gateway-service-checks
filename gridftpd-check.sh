#!/bin/sh

if [[ $# -ne 1 ]] ; then
  echo Usage: $0 hostname
  exit 1
fi

host=$1

.  /etc/sysconfig/gateway-service-check

grid-proxy-init -valid 0:10 >/dev/null


globus-url-copy  file://${source}  gsiftp://${host}/${target} || { echo Transfer IN failed;  exit 1; } 

globus-url-copy gsiftp://${host}/${target} file://${fileback}  || { echo Transfer BACK failed; exit 1; }

cmp ${source}  ${fileback} || { echo Source file and retrieved file are not the same >/dev/stderr; exit 1; }

