#!/bin/bash

bold=$'\e[1m'
yellow=$'\e[93m'
end=$'\e[0m'
green=$'\e[92m'

function banner() {
#
echo -e "                         _     _                     ______"
echo -e "                        (_)   | |                    | ___ "'\'" "
echo -e "     _ __   ___ _ __ ___ _ ___| |_ ___ _ __   ___ ___| |_/ / "
echo -e "    | '_ \ / _ \ '__/ __| / __| __/ _'\' _ \ / __/ _ \ ___ "'\'" "
echo -e "    | |_) |  __/ |  \__ \ \__ \ ||  __/ | | | (_|  __/ |_/ / "
echo -e "    | .__/ \___|_|  |___/_|___/\__\___|_| |_|\___\___\____/  "
echo -e "    | |                                                      "
echo -e "    |_|                                                      "
#
echo -e "##############################################################"
echo -e " \n"
#
echo -e " $bold 1) USB ENCRYPTED PERSISTENCE "

echo -e " $bold 2) USB PERSISTENCE "
#
echo -e " \n"
}
############################################################################################################################################################

function encrypted_persistance() {

    sleep 2
    cryptsetup --verbose --verify-passphrase luksFormat /dev/$partition 
#
    sleep 2
    cryptsetup luksOpen /dev/$partition my_usb 
#
    sleep 2
    mkfs.ext4 -L persistence /dev/mapper/my_usb &&
#
    sleep 2
    e2label /dev/mapper/my_usb persistence &&
#
    sleep 2
    mkdir -p /mnt/my_usb &&
#
    sleep 2
    mount /dev/mapper/my_usb /mnt/my_usb 
#
    sleep 2
    echo "/ union" > /mnt/my_usb/persistence.conf &&
#
    sleep 2
    umount /dev/mapper/my_usb 
#
    sleep 2
    cryptsetup luksClose /dev/mapper/my_usb

}

function just_persistence() {

    sleep 2
    mkfs.ext4 -L persistence /dev/$partition &&
#
    sleep 2
    e2label /dev/$partition persistence &&
#
    sleep 2
    mkdir -p /mnt/my_usb &&
#
    sleep 2
    mount /dev/$partition /mnt/my_usb &&
#
    sleep 2
    echo "/ union" > /mnt/my_usb/persistence.conf &&
#
    sleep 2
    umount /dev/$partition  

}

#############################################################################################################################################################

function questions() {
#
    fdisk -l; 
#
    echo -e "\n"
#
    read -p " ${bold}Enter the disk partition name : " partition 

    echo -e "\n"
#
    if [[ ${#partition} -eq 4 ]]; then
#
        read -p " Are you sure ${yellow}$partition${end}$bold is the disk partition ( y/n ) ? : " choice
#
    else
#
        echo -e "${yellow}---------------------->  ENTER CORRECT PARTITON NAME  <--------------------${end}$bold";   
#       
        main
#        
    fi
}

#############################################################################################################################################################

function again() {

    echo -e "${yellow} ----------------->  ENTER CORRECT OPTION  <---------------------${end}"
            
    main
}



#############################################################################################################################################################


function main() {
#
    banner
#   
    if [[ $(id -u) -ne 0 ]] ; then echo "  ${yellow}----------> Run as root user <----------  ${end}" ; echo -e "\n"; exit 1 ; fi   # CHECKS ROOT USER

    read -p " Enter your choice : " options
#   
    if [[ $options -eq 1 ]]; then
#      
        questions 
    #  
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then

            encrypted_persistance

        else
            exit
        fi       
    #    
    elif [[ $options -eq 2 ]]; then 
#    
        questions   
    #
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then

            just_persistence     

        else
            exit
       fi      
    #
    else 
        again
    #    
    fi
}

main
