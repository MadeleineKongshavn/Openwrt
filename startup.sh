#!/bin/sh
# Most routers have tiny storage capacity with a lot of them barely having enough to store SSL libraries and/or
# root certificates. OpenWrt comes builtin with a minimal version of wget which does not support SSL due to size constraints.

# wget is a program for retrieving content from web servers and is used by OpenWrt through 'opkg update' and 'opkg install'.
# This script install the necessary packet to and does the configuration steps needed to set up SSL support for OpenWrt

# Tested on Raspberry-pi-4-model-b
# OpenWrt version 21.02
#
#
#
#

# Find all occurences of https:// and replace them with http://.
# This allow us to install packages without needing SSL support and not needing to add '--no-check-certificate'.

hostname=$1
# Setting hostname to the input 
sed -i "s/option hostname 'OpenWrt'/option hostname \'$hostname\'/gI"  /etc/config/system

FILE=/etc/opkg/distfeeds.conf
if test -f "$FILE"; then
   sed -i 's/https:\/\//http:\/\//gI' $FILE
else
    echo "WARNING: $FILE not found...."
    sleep 2
fi


# Fetch list of available packages from the OpenWrt pkt repos.
opkg update
##Do status become > 0 when not being able to run 'opkg update'?

status=$?
if [ $status -ne 0 ];
then
    echo -e "\n\nSomething went wrong during 'opkg update'"
    echo "Continue startup script? (y,n)"
    read value

    if [[ "$value" != "y" ]];
    then
        echo "Exiting script!"
        exit 0
    fi
fi


## Installing and configuring NTP.


#Do wrong installation of packet leads to > 0 exit code?
opkg install ntpdate
echo "Configuring date and time......"
da=$(ntpdate pool.ntp.org)
status=$?

if [ $status -ne  0 ];
then
    echo "ntpdate returned exit status code $status"
    echo "NOTE: Outward access to UDP port 123 and response is needed for NTP syncronization"
    echo $da

    echo -e "\nDo you want to configure date and time manually? (y, n)"
    read input
    while [[ $input != "y" ]] && [[ $input != "n" ]];
    do
       echo "Do you want to configure date and time manually? (y, n)"
       read input
    done

    #Configure date manually
    if [[ $input == "y" ]];
    then
        echo "Date format: YYYY-MM-DD hh:mm"
        read inputdate
        v=$(date -s "$inputdate")

        status=$?
        while [[ $status -ne 0 ]];
        do
            read inputdate
            v=$(date -s "$inputdate")
            status=$?

            if [[ $status -ne 0 ]];
            then
                echo "Wrong input format! Date format: YYYY-MM-DD hh:mm"
            fi
        done

    fi
fi

d=$(date)
echo "Date configured as: $d"
echo "Installing necessary packets...."
sleep 2

# Make the directory for the SSL certs
mkdir -p /etc/ssl/certs
# Set the directory so wget knows where to look
export SSL_CERT_DIR=/etc/ssl/certs

pktAll=("librt" "libpcre" "zlib" "libc" "ca-bundle" "libustream-openssl" "ca-certificates" "wget-ssl" "nano" "bash")
for t in ${pktAll[@]}; do
    opkg install $t
    if [[ $? != 0 ]];
    then
        echo "Error occured while trying to install $t"
        sleep 3
    fi
done


pkts=("librt" "libpcre" "zlib" "libc" "ca-bundle" "ca-certificates" "libustream-openssl*" "wget-ssl" "ntpdate" "nano" "bash");
echo "-----------------------------------------------------------------------------------------------------"
for t in ${pkts[@]}; do
   v=$(opkg list_installed $t)
   if [ -n "$v" ];
   then
       echo -e "OK\t\t\t\t\t\t\t$v"
   else
       echo  -e "NOT FOUND\t\t\t\t\t\t$t"
   fi
done
echo "-----------------------------------------------------------------------------------------------------"


d=$(date)
echo "Date set to: $d"

# Configure HTTPS
sed -i 's/http:\/\//https:\/\//gI' $FILE








echo
echo "--------------------------------"
echo "SSL setup is complete           "
echo "--------------------------------"
echo

