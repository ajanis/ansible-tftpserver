#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 6. AMI BMC Erase and re-install

source include.sh

if [ ! -e SIAD_BMC_v${BMC_VERSION}.ima ]
then
	log Downloading BMC Utility ${BMC_VERSION}
	wget ${SIAD_URL}/bmc/v${BMC_VERSION}/SIAD_BMC_v${BMC_VERSION}.ima 
fi

Yafuflash_Linux64 -cd SIAD_BMC_v${BMC_VERSION}.ima <<EOF 
n
3
y
y
EOF

if [ $? -ne 0 ]
then
	logerr BMC Firmware update failed!!! Please investigate further.
else 
	log BMC Firmware update completed successfully.  Sleeping for 5 minutes before running verification.
	sleep 300
	Yafuflash_Linux64 -cd -mi 
fi
