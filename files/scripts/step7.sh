#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 7. CPU CPLD erase and re-install

source include.sh

if [ ! -e SIAD_CPU_CPLD_v${CPU_CPLD_VERSION}.jbc ]
then
	log Downloading CPU CPLD ${CPU_CPLD_VERSION}...
	wget ${SIAD_URL}/cpu_cpld/v${CPU_CPLD_VERSION}/SIAD_CPU_CPLD_v${CPU_CPLD_VERSION}.jbc 
fi

jbi -aprogram -dDO_BYPASS_UFM=1 -dDO_REAL_TIME_ISP=1 SIAD_CPU_CPLD_v${CPU_CPLD_VERSION}.jbc 

jbi -aVERIFY -dDO_BYPASS_UFM=1 -dDO_REAL_TIME_ISP=1 SIAD_CPU_CPLD_v${CPU_CPLD_VERSION}.jbc 

if [ $? -ne 0 ]
then
	logerr CPU CPLD install verification failed!! Please manually reinstall CPU CPLD Firmware.
else 
	log CPU CPLD firmare verification successful.
fi
