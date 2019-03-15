#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 4. BSP Erase and re-install

source include.sh

log Installed version of SIAD GSP Utils: $(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}')

#echo -e "\n--- SIAD BSP Utils v.$(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}') ---\n"

dpkg -r siad-bsp-utils 
find / -name SIAD_BSP_UTIL*.egg -exec rm {} \; 
if [ ! -e siad-bsp-utils_${BSP_VERSION}-${BSP_RELEASE}_amd64.deb ]
then
	log Downloading BSP Utils Version ${BSP_VERSION}
	#echo -e "\n Downloading BSP Utils Version ${BSP_VERSION}...\n"
	wget ${SIAD_URL}/bsp/v${BSP_VERSION}/siad-bsp-utils_${BSP_VERSION}-${BSP_RELEASE}_amd64.deb 

fi
log Installing BSP Utils Version ${BSP_VERSION}
#echo -e "\n Installing BSP Utils Version ${BSP_VERSION}...\n"
dpkg -i siad-bsp-utils_${BSP_VERSION}-${BSP_RELEASE}_amd64.deb > /dev/null 2>&1

if [ $? -eq 0 ]
then 
log Installed version of SIAD GSP Utils: $(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}')
fi

#echo -e "\n--- SIAD BSP Utils v.$(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}') ---\n"