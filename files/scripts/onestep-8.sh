#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 8. Main Board CPLD erase and re-install

# NOTES:
# If we do not have to reboot between CPLD 0 and 1 upgrades
# then we can entirely skip the reboot process and
# automate both upgrades with no extra user interaction

source include.sh


if [ ! -e SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd ]
then
	log Downloading Main Board CPLD Image v${CPU_CPLD_VERSION}_${CPU_CPLD_RELEASE}...
	wget ${SIAD_URL}/mb_cpld/v${MB_CPLD_VERSION}/SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd > >(tee -a $LOGFILE) 2>&1
fi
log Switching i2c from BMC to x86
ipmitool raw 0x3c 0x11 0x65 0x1 0x1 > >(tee -a $LOGFILE) 2>&1
log Main Board CPLD 0 : Starting firmware upgrade.
cpld_upgrade 0 SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd > >(tee -a $LOGFILE) 2>&1
cpld_readtofile 0 /tmp/cpld-0.rpd 143360 > >(tee -a $LOGFILE) 2>&1
log SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd MD5: $(md5sum SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd | awk '{print $1}')
log /tmp/cpld-0.rpd MD5: $(md5sum /tmp/cpld-0.rpd | awk '{print $1}')
if [[ "$(md5sum SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd | awk '{print $1}')" == "$(md5sum /tmp/cpld-0.rpd | awk '{print $1}')" ]]
then
	log Main Board CPLD 0 :  Firmware verification successful.
	log Main Board CPLD 1 : Starting firmware upgrade. 
	cpld_upgrade 1 SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd > >(tee -a $LOGFILE) 2>&1
	cpld_readtofile 0 /tmp/cpld-1.rpd 143360 > >(tee -a $LOGFILE) 2>&1
	log SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd MD5: $(md5sum SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd | awk '{print $1}')
	log /tmp/cpld-1.rpd MD5: $(md5sum /tmp/cpld-1.rpd | awk '{print $1}')
	if [[ "$(md5sum SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd | awk '{print $1}')" == "$(md5sum /tmp/cpld-1.rpd | awk '{print $1}')" ]]
	then
		log Main Board CPLD 1 : Firmware verification successful.
		log Reverting i2c from x86 to BMC
		ipmitool raw 0x3c 0x11 0x65 0x1 0x0 > >(tee -a $LOGFILE) 2>&1
	else 
		logerr Main Board CPLD 1 : Firmware verification failed! Please manually reinstall Main Board CPLD 1 Firmware.
	fi
else 
	logerr Main Board CPLD 0 : Firmware verification failed! Please manually reinstall Main Board CPLD 0 firmware.
fi
