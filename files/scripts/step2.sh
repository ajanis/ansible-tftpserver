#!/bin/sh
# UFISpace Firmware Upgrade SOP
# 2. SSD Format and ONIE Installation

LOGFILE=itc_build_output.log

function log {
	echo
    echo "[$(date --rfc-2822)]: $*" | tee -a $LOGFILE
    echo
}

function logerr {
	echo
    echo "[$(date --rfc-2822)]: ERROR :: $*" >&2 | tee -a $LOGFILE
    echo
}

log Unmounting existing partitions
for PART in $(mount | grep sda | awk '{print $1}')
do
umount -lf ${PART}
done 2>&1 | tee -a $LOGFILE 

log Removing existing partitions
for PART in $(parted -m /dev/sda print | tail -n +3 | cut -d ":" -f1)
do
log Removing Partition ${PART}
parted -ms /dev/sda rm ${PART}
done 2>&1 | tee -a $LOGFILE

log Securely Erasing Disk

#dd if=/dev/zero of=/dev/sda

# Since these machines use SSDs, overwriting with zeros is NOT a good option.
# Most SSDs are intelligent and if they see a full sector filled with zeros they do not write,
# they mark it for erase.
# The best option is to re-format partition as ext4 
# (without full re-format, just a fast one, only structures) 
# on a modern linux kernel it will do a trim on the whole partition prior to format it.

# overwrite entire disk with ext4 filesystem
# trims all existing partitions
mkfs.ext4 -F -E lazy_itable_init=1 /dev/sda 2>&1 | tee -a $LOGFILE

# remove newly created partition
parted -ms /dev/sda rm 1 2>&1 | tee -a $LOGFILE

# create new partitions
log Creating GPT partition table on sda
parted -ms /dev/sda mktable gpt 2>&1 | tee -a $LOGFILE
log Creating primary partition on sda
parted -ms /dev/sda mkpart primary 0% 100% 2>&1 | tee -a $LOGFILE
log Creating Ext3 filesystem on sda1
mkfs.ext3 -F /dev/sda1 2>&1 | tee -a $LOGFILE

log New Partition Information
parted /dev/sda print | tail -n +3 2>&1 | tee -a $LOGFILE