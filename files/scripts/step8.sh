#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 8. Main Board CPLD erase and re-install

# NOTES:
# If we do not have to reboot between CPLD 0 and 1 upgrades
# then we can entirely skip the reboot process and
# automate both upgrades with no extra user interaction

source include.sh

usage() {
	echo -e "\n Please enter cpld0 or cpld1 \n"
	mb_cpld_upgrade
}

mb_cpld_upgrade() {
echo -e "\n Which CPLD would you like to upgrade? [ cpld0 | cpld1 ] : "
read CPLD
log $CPLD
if [ ! -e SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd ]
then
	log Downloading Main Board CPLD Image v${CPU_CPLD_VERSION}_${CPU_CPLD_RELEASE}...
	wget ${SIAD_URL}/mb_cpld/v${MB_CPLD_VERSION}/SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd 
fi

case $CPLD in
	cpld0|0)
		ipmitool raw 0x3c 0x11 0x65 0x1 0x1 
		cpld_upgrade 0 SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd 
		cpld_readtofile 0 /tmp/cpld-${CPLD}.rpd 143360 
		log SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd MD5: $(md5sum SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd | awk '{print $1}')
		log /tmp/cpld-${CPLD}.rpd MD5: $(md5sum /tmp/cpld-${CPLD}.rpd | awk '{print $1}')
		if [[ "$(md5sum SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd | awk '{print $1}')" == "$(md5sum /tmp/cpld-${CPLD}.rpd | awk '{print $1}')" ]]
		then
			log Main Board CPLD ${CPLD} firmware verification successful.  Rebooting...
			ipmitool power cycle 		
		else 
			logerr Main Board CPLD 0 firmware verification failed! Please manually reinstall Main Board CPLD ${CPLD} firmware.
		fi
		;;
	cpld1|1)
		ipmitool raw 0x3c 0x11 0x65 0x1 0x1 
		cpld_upgrade 1 SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd 
		cpld_readtofile 0 /tmp/cpld-${CPLD}.rpd 143360 
		log SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd MD5: $(md5sum SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd | awk '{print $1}')
		log /tmp/cpld-${CPLD}.rpd MD5: $(md5sum /tmp/cpld-${CPLD}.rpd | awk '{print $1}')
		if [[ "$(md5sum SIAD_MB_CPLD_v${MB_CPLD_VERSION}_${MB_CPLD_RELEASE}_auto.rpd | awk '{print $1}')" == "$(md5sum /tmp/cpld-${CPLD}.rpd | awk '{print $1}')" ]]
		then
			log Main Board CPLD ${CPLD} firmware verification successful.  Rebooting...
			ipmitool raw 0x3c 0x11 0x65 0x1 0x0 
			ipmitool power cycle 
		else 
			logerr Main Board CPLD ${CPLD} firmware verification failed! Please manually reinstall Main Board CPLD ${CPLD} Firmware.
		fi
		;;
	*)
		usage
		exit
		;;
esac
}

mb_cpld_upgrade