#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 10. UCD90124A (Hardware Monitor) update

source include.sh

if [ ! -e SIAD_UCD9_PVT2-2_OR_Later_R${UCD_VERSION}_${UCD_RELEASE}.hex ]
then
	log Downloading UCD Firmware SIAD_UCD9_PVT2-2_OR_Later_R${UCD_VERSION}_${UCD_RELEASE}.hex
	wget ${SIAD_URL}/ucd/v${UCD_VERSION}/SIAD_UCD9_PVT2-2_OR_Later_R${UCD_VERSION}_${UCD_RELEASE}.hex 
fi

log Upgrading UCD Firmware
/usr/sbin/updateUCD90124a.sh SIAD_UCD9_PVT2-2_OR_Later_R${UCD_VERSION}_${UCD_RELEASE}.hex 

if [ $? -ne 3 ]
then
	logerr UCD firmware upgrade failed!!  Please investigate further.
else
	/usr/sbin/verifyUCD90124a.sh SIAD_UCD9_PVT2-2_OR_Later_R${UCD_VERSION}_${UCD_RELEASE}.hex 
	#log UCD firmware upgrade successful.  Rebooting
	#ipmitool raw 0x3c 0x24 0x01 0x00 
	log UCD firmware upgrade successful.
	log Rebooting BMC and system to finalize all firmware updates.
	ipmitool raw 0x3c 0x24 0x01 0x00    
fi
