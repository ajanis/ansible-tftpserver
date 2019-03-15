SIAD_URL="http://10.253.63.4/siad"


wget http://10.253.63.4/siad/scripts/step2.sh && chmod +x step2.sh
./step2.sh


#fix network interfaces
sed -i 's/ens33/eth0/g' /etc/network/interfaces && service networking restart

# download scripts
wget -r -nH --cut-dirs=1 -np -R "index.html*"  http://10.253.63.4/siad/scripts/ && chmod +x scripts/*

#BSP_VER=3.0.2
#CUR_BSP_VER=$(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}')
#
#if [ "$CUR_BSP_VER" != "$BSP_VER" ]
#then
#dpkg -r siad-bsp-utils
#find / -name SIAD_BSP_UTIL*.egg | xargs rm
#wget http://10.253.63.4/siad/bsp/SIAD_BSP_Release_V3.0.2/SIAD_BSP_Release_V3.0.2/siad-bsp-utils_3.0.2-1_amd64.deb
#dpkg -i siad-bsp-utils_3.0.2-1_amd64.deb
#fi
#
#[ "$(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}')" == "$BSP_VER" ] && echo "--- SIAD BSP Utils v.${BSP_VER} is up to date ---"

BMC_RELEASE=$(echo ${BMC_VERSION} | cut -d "-" -f1)

echo -e "\n--- SIAD BSP Utils v.$(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}') ---\n"

dpkg -r siad-bsp-utils
find / -name SIAD_BSP_UTIL*.egg | xargs rm
wget ${SIAD_URL}/bsp/SIAD_BSP_Release_V${BMC_RELEASE}/SIAD_BSP_Release_V${BMC_RELEASE}/siad-bsp-utils_${BMC_VERSION}_amd64.deb
dpkg -i siad-bsp-utils_${BMC_VERSION}_amd64.deb


echo -e "\n--- SIAD BSP Utils v.$(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}') ---\n"

wget ${SIAD_URL}/bios/SIAD_BIOS_Release_R04.3/T77O994T01_R04.3.bin
wget ${SIAD_URL}/bios/SIAD_BIOS_Release_R04.3/bios.xml

ioset 0x604 0x00
flashrom -p internal:boardmismatch=force -l bios.xml -i bios -w T77O994T01_R04.3.bin -c MX25L12835F/MX25L12845E/MX25L12865E -A -V

echo -e "\n--- BIOS v.$(dmidecode -s bios-version) ---\n"


reboot


echo -e "\n--- SIAD BSP Utils v.$(dpkg -l siad-bsp-utils | tail -n1 | awk '{print $3}') ---\n"

wget ${SIAD_URL}/bios/SIAD_BIOS_Release_R04.3/T77O994T01_R04.3.bin
wget ${SIAD_URL}/bios/SIAD_BIOS_Release_R04.3/bios.xml

ioset 0x604 0x80
flashrom -p internal:boardmismatch=force -l bios.xml -i bios -w T77O994T01_R04.3.bin -c MX25L12835F/MX25L12845E/MX25L12865E -A -V

echo -e "\n--- BIOS v.$(dmidecode -s bios-version) ---\n"

echo -e "\n"
./TPMFactoryUpd -info | egrep -i "(family|firmware)" | tr -d " " |awk -F ":" '{print $1":",$2}'
echo -e "\n"

sh -c "tpm -g" | egrep -i "(family|firmware)"




./TPMFactoryUpd -info | egrep "(family|firmware)" | awk '{print $NF}' | tr -s '\n' ' ' | read -r family firmwareecho -e "\n family: $family \n firmware: $firmware \n"


while read FAMILY FW_VERSION; do echo -e "\n TPM Family: ${FAMILY}"; echo -e "\n TPM Firmware Version: ${FW_VERSION}"; done <<<$(./TPMFactoryUpd -info | egrep "(family|firmware)" | awk '{print $NF}')

• onie-discovery-stop
• wget http://10.253.63.4/siad/nos/vyatta-bedford-ea6-amd64-vrouter.iso-ONIE.bin &&
chmod +x vyatta-bedford-ea6-amd64-vrouter.iso-ONIE.bin
• onie-nos-install vyatta-bedford-ea6-amd64-vrouter.iso-ONIE.bin

/usr/bin/wget http://10.253.63.4/siad/scripts/appendix_c.sh && /bin/chmod +x appendix_c.sh