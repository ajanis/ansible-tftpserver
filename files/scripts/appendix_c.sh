#!/bin/bash
# UFISpace Firmware Upgrade SOP
# Appendix C - NOS Validation

LOGFILE=nos_validation.log

/bin/lsblk > >(tee -a $LOGFILE) 2>&1
show version > >(tee -a $LOGFILE) 2>&1

#no sudo privs
sudo dmidecode -s bios-version > >(tee -a $LOGFILE) 2>&1
sudo ipmitool bmc info > >(tee -a $LOGFILE) 2>&1
sudo ipmitool sel > >(tee -a $LOGFILE) 2>&1
sudo ipmitool sensor > >(tee -a $LOGFILE) 2>&1

free -tm > >(tee -a $LOGFILE) 2>&1
ps aux | sort -nrk 3,3 | head -n 5 > >(tee -a $LOGFILE) 2>&1

show interfaces > >(tee -a $LOGFILE) 2>&1
show configuration commands > >(tee -a $LOGFILE) 2>&1
