#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 5. BIOS Erase and re-install


# NOTES:
# If we do not have to reboot to each SPI to install the other and 
# if we can verify and trust that the installation was successful by some other means
# then we can entirely skip the reboot process and
# automate both upgrades with no extra user interaction

source include.sh

#BIOS_RELEASE=$(echo $BIOS_VERSION | cut -d "_" -f2)





if [ ! -e T77O994T01_R0${BIOS_VERSION}.bin ]
then
	log Downloading BIOS Firmware T77O994T01_R0${BIOS_VERSION}.bin
	wget ${SIAD_URL}/bios/v${BIOS_VERSION}/T77O994T01_R0${BIOS_VERSION}.bin
	wget ${SIAD_URL}/bios/v${BIOS_VERSION}/bios.xml
fi

if [ ! -e bios.xml ]
then
	log Downloading bios.xml
	wget ${SIAD_URL}/bios/v${BIOS_VERSION}/bios.xml
fi

log SPI0 : Starting BIOS upgrade.
ioset 0x604 0x00
flashrom -p internal:boardmismatch=force -l bios.xml -i bios -w T77O994T01_R0${BIOS_VERSION}.bin -c MX25L12835F/MX25L12845E/MX25L12865E -A -V
if [ $? -eq 0 ]
then
	log SPI0 : BIOS upgrade successful.  Version: $(dmidecode -s bios-version)
	log SPI1 : Starting BIOS upgrade.
	ioset 0x604 0x80 >> $LOGFILE 2>&1
	flashrom -p internal:boardmismatch=force -l bios.xml -i bios -w T77O994T01_R0${BIOS_VERSION}.bin -c MX25L12835F/MX25L12845E/MX25L12865E -A -V
    if [ $? -eq 0 ]
    then
		log SPI1 : BIOS upgrade successful.  Version: $(dmidecode -s bios-version)
	else 
		logerr SPI1 : BIOS upgrade failed! Please investigate and manually reinstall BIOS firmware.
	fi

else 
	logerr SPI0 : BIOS upgrade failed! Please investigate and manually reinstall BIOS firmware.
fi


if [[ "$(ioget 0x604 | awk '{print $NF}')" == "0x80" && "$(dmidecode -s bios-version)" == "T77O994T01_R0${BIOS_VERSION}" ]] 
then
	log Resetting primary SPI to SPI0
	ioset 0x604 0x00
fi

