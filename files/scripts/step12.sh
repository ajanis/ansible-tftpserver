#!/bin/bash
# UFISpace Firmware Upgrade SOP
# 12. EEPROM

source include.sh

echo -e "\n Collecting CPU board EEPROM ... \n" 
i2cdump -y 0 0x57 c | tee cpu_board_eeprom.out 
echo -e "\n ... saved to cpu_board_eeprom.out \n\n" 

echo -e "\n Collecting Main board EEPROM ... \n" 
ioset 0x706 0xe8 
i2cset -y 0 0x70 0x8 
i2cdump -y 0 0x56 c | tee main_board_eeprom.out 
ioset 0x706 0xc0 
echo -e "\n ... saved to main_board_eeprom.out \n\n" 

echo -e "\n Collecting Fan board EEPROM ... \n" 
ioset 0x706 0xe8 
i2cdump -y 0 0x54 c | tee fan_board_eeprom.out 
ioset 0x706 0x40 
echo -e "\n ... saved to fan_board_eeprom.out \n\n" 

echo -e "\n Collecting DPLL EEPROM ... \n" 
i2cset -y 0 0x75 8 
i2cdump -y 0 0x53 | tee dpll_eeprom.out 
echo -e "\n ... saved to dpll_eeprom.out \n\n" 

log Rebooting system for NOS installation.
ipmitool power cycle 