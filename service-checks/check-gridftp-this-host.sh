#!/bin/sh
PATH=$PATH:/opt/service-checks

run-service-check.sh $(hostname) gridftp
