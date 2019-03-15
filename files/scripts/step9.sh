#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 9. Intel Broadwell-DE integrated Ethernet (10GE-KR) and I210 firmware re-install

source include.sh

if [ ! -e SIAD_10GEKR_v${TENGEKR_VERSION}.bin ]
then
	log Downloading 10GE-KR Firmware SIAD_10GEKR_v${TENGEKR_VERSION}.bin ...
	wget ${SIAD_URL}/10ge-kr/v${TENGEKR_VERSION}/SIAD_10GEKR_v${TENGEKR_VERSION}.bin 
fi

if [ ! -e SIAD_I210_v${I210_VERSION}_${I210_RELEASE}.bin ]
then
	log Downloading I210 Firmware SIAD_I210_${I210_VERSION}_${I210_RELEASE}.bin ...
	wget ${SIAD_URL}/i210/v${I210_VERSION}/SIAD_I210_v${I210_VERSION}_${I210_RELEASE}.bin 
fi


TENGBE_NIC=$(eeupdate64e /ALL /EEPROMVER | grep -i "10 gbe" | awk '{print $1}' | head -n1)
I210_NIC=$(eeupdate64e /ALL /EEPROMVER | grep -i "i210" | awk '{print $1}' | head -n1)

log Updating 10GE-KR Firmware ...
eeupdate64e /NIC=${TENGBE_NIC} /D SIAD_10GEKR_v${TENGEKR_VERSION}.bin 
TENGBE_STATUS=$?

log Updating I210 Firmware ...
eeupdate64e /NIC=${I210_NIC} /D SIAD_I210_v${I210_VERSION}_${I210_RELEASE}.bin 
I210_STATUS=$?


if [ ${TENGBE_STATUS} -ne 0 ]
then
	logerr 10GE-KR firmware installation failed!!  Please investigate further.
else
	log 10GB-KR firmware installation successful ...  
	log 10GB-KR firmware image version:  $(eeupdate64e /NIC=${TENGBE_NIC} /EEPROMVER | tail -n1 | awk '{print $NF}')
fi


if	[ ${I210_STATUS} -ne 0 ]
then
	logerr I210 firmware installation failed!!  Please investigate further.
else 
	log I210 firmware installation successful ...  
	log I210 firmware image version: $(eeupdate64e /NIC=${I210_NIC} /EEPROMVER | tail -n1 | awk '{print $NF}')
fi
