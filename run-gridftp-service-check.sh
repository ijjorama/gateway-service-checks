#!/bin/bash

failed=/tmp/gw-check-failed
succeeded=/tmp/gw-check-succeeded

rm -f ${succeeded} ${failed}

/etc/grid-security/gateway-service-check.sh $(hostname)

if [[ $? -ne 0 ]] ; then

  touch ${failed}

else 
 
  touch ${succeeded}

fi

