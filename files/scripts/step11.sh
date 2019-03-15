#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 11. TPM

source include.sh

cd /root/DIAG/DNX_QAX_DIAG/

log Gathering TPM Information ...

./TPMFactoryUpd -info | egrep -a "(family|firmware)"| tr -d " " |awk -F ":" '{print $1":",$2}' 

log Gathering UFI Diag information ... This may take some time ...

./runbcm.sh ufi <<EOF | egrep -a "(TPM_PT_FAMILY_INDICATOR|TPM_PT_FIRMWARE_VERSION)" 
tpm -g
tpm -t FULL
exit
EOF

echo -e "\n"


#echo -e "\n TPM Information Capture ..."
#egrep -a "(family|firmware)" /root/tpm_factory.out | tr -d " " |awk -F ":" '{print $1":",$2}'
#echo -e "\n UFI DIAG Tool Capture ..."
#egrep -a "(TPM_PT_FAMILY_INDICATOR|TPM_PT_FIRMWARE_VERSION)" /root/tpm_output.txt