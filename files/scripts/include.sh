#!/bin/bash

source env.sh

# Global functions
LOGFILE=itc_build_output.log
exec 1> >(tee -a >(logger -t ufi-install -n 10.253.63.4)) 2>&1

function log {
	echo "$*"
    #echo "[$(date --rfc-3339=seconds)]: $*" #| tee -a $LOGFILE
    #logger -t ufi-install "$@" -n 10.253.63.4
    #echo
}

function logerr {
	echo "$*" >&2
    #echo "[$(date --rfc-3339=seconds)]: ERROR :: $*" >&2 #| tee -a $LOGFILE
    #logger -t ufi-install "$@" -p user.err -n 10.253.63.4 
    #echo
}