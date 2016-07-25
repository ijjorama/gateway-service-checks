#!/bin/sh

if [[ $# -ne 1 ]] ; then
  echo Usage: $0 hostname
  exit 1
fi
#set -x

host=$1

.  /etc/sysconfig/gateway-service-check


grid-proxy-init -valid 0:10 >/dev/null

#if [[ $? != 0 ]] ; then
#  exit 1
#fi

#  ||
# { echo Creating Grid proxy failed > /dev/stderr; exit 1; }



globus-url-copy  file://${source}  gsiftp://${host}/${target} || { echo Transfer IN failed;  exit 1; } 
 
 
#{  echo Copy into GridFTP failed > /dev/stderr ;  exit 1; }

globus-url-copy gsiftp://${host}/${target} file://${fileback}  || { echo Transfer BACK failed; exit 1; }
#{  echo Copy back from GridFTP failed > /dev/stderr; exit 1; }

cmp ${source}  ${fileback} || { echo Source file and retrieved file are not the same >/dev/stderr; exit 1; }

