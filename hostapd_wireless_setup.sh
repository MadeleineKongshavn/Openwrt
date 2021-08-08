#!/bin/bash

## Seting up a node (AP) as a wireless access ponint and configuring access to both the wireless
## access point from the client and allowing the client to access the internet through the AP, instead of the client 
## only having access to the AP.  

# Internet         wireless
# ---------- [AP] <*

#
## Necessary files to confgiure
#
files=("/etc/config/wireless" "/etc/config/network" "/etc/config/dhcp" "/etc/config/firewall")
#
## The country code! 00 means unset
#
countryCode="$(iw reg get | awk {'print $2'} | cut -c 1-2 | head -n 2 | tail -n 1)"
#
## Bash version needs to be 4 or higher. 
#
versionNumber="$(bash -version | egrep 'version' | egrep -o 'version\ [0-9]{1}\.*[0-9]
{1}\.[0-9]{1}' | awk {'print $2'} | cut -c 1-1)"
#
## Full bash version number
#
version="$(bash -version | egrep 'version' | egrep -o 'version\ [0-9]{1}\.*[0-9]{1}\.[0-9]{1}')"


function FindCopyToFile() ## Over 255 files means error later in script.
{
    for i in {1..255}
    do
        if [ -f "$1.$i" ];
        then
            return "$1.$i"
        fi
    done
}


if [[ $countryCode == "00" ]];
then 
    echo "Country code does not seem to be set... exiting.."
    exit 0
else
    echo "Country code: $countryCode"
fi

echo "Bash $version"

ok=1
for file in "${files[@]}"
do
        if [ ! -f "$FILE" ];
        then
                echo -e "EXIST\t\t\t$file"
        else
                echo -e "NOT EXIST\t\t\t$file"
                ok=0
        fi
done
if [ ! $code ];
then
    echo -e "\nSome files seems to not exist... exiting..."
    exit 0
fi



######
######
######                  Starting configuration of files. 
######
######

copyToFile = FindCopyToFile ${files[0]}
cp ${files[0]} $copyToFile

echo "config wifi-device 'radio0'"                                                              >> ${files[0]}
echo "        option type 'mac80211'"                                                           >> ${files[0]}
echo "        option path 'platform/soc/fe300000.mmcnr/mmc_host/mmc1/mmc1:0001/mmc1:0001:1'"    >> ${files[0]}
echo "        option cell_density '0'"                                                          >> ${files[0]}
echo "        option country 'US'"                                                              >> ${files[0]}
echo "        option hwmode '11a'"                                                              >> ${files[0]}
echo "        option htmode 'VHT20'"                                                            >> ${files[0]}
echo "        option channel 'auto'"                                                            >> ${files[0]}
echo ""                                                                                         >> ${files[0]}
echo "config wifi-iface 'default_radio0'"                                                       >> ${files[0]}
echo "        option device 'radio0'"                                                           >> ${files[0]}
echo "        option network 'wifi'"                                                            >> ${files[0]}
echo "        option mode 'ap'"                                                                 >> ${files[0]}
echo "        option ssid 'OpenWrt1'"                                                           >> ${files[0]}
echo "        option encryption 'none'"                                                         >> ${files[0]}


copyToFile = FindCopyToFile ${files[1]}
cp ${files[1]} $copyToFile

## Adding IP address for wireless interface into /etc/config/network 
echo ""                                             >> ${files[1]}
echo "config 'interface' 'wifi'"                    >> ${files[1]}
echo "        option 'proto' 'static'"              >> ${files[1]}
echo "        option 'ipaddr' '192.168.2.1'"        >> ${files[1]}
echo "        option 'netmask' '255.255.255.0'"     >> ${files[1]}
                                                        
                                                        
copyToFile = FindCopyToFile ${files[2]}                  
cp ${files[2]} $copyToFile

echo ""                                             >> ${files[2]}                                                        
echo "config 'dhcp' 'wifi'"                         >> ${files[2]}
echo "       option 'interface' 'wifi'"             >> ${files[2]}
echo "       option 'start' '100'"                  >> ${files[2]}
echo "       option 'limit' '150'"                  >> ${files[2]}
echo "       option 'leasetime' '12h'"              >> ${files[2]}



copyToFile = FindCopyToFile ${files[3]}
cp ${files[3]} $copyToFile

echo "config zone"                                  >> ${files[3]}                       
echo "        option name wifi"                     >> ${files[3]}
echo "        list network 'wifi'"                  >> ${files[3]}
echo "        option input ACCEPT"                  >> ${files[3]}
echo "        option output ACCEPT"                 >> ${files[3]}
echo "        option forward REJECT"                >> ${files[3]}
echo ""                                             >> ${files[3]}
echo "config 'forwarding'"                          >> ${files[3]}
echo "        option 'src' 'wifi'"                  >> ${files[3]}
echo "        option 'dest' 'wan'"                  >> ${files[3]}
echo ""                                             >> ${files[3]}
echo "config 'forwarding'"                          >> ${files[3]}
echo "       option 'src' 'lan'"                    >> ${files[3]}
echo "       option 'dest' 'wifi'"                  >> ${files[3]}
echo ""                                             >> ${files[3]}
echo "config 'forwarding'"                          >> ${files[3]}
echo "       option 'src' 'wifi'"                   >> ${files[3]}
echo "       option 'dest' 'lan'"                   >> ${files[3]}
echo ""                                             >> ${files[3]}
echo "config zone"                                  >> ${files[3]}
echo "       option name lan"                       >> ${files[3]}
echo "       list network 'lan'"                    >> ${files[3]}
echo "       option input ACCEPT"                   >> ${files[3]}
echo "       option output ACCEPT"                  >> ${files[3]}
echo "       option forward ACCEPT"                 >> ${files[3]}
echo "       option masq 1"                         >> ${files[3]}

######
######
######                  Configuration of files finished. 
######
######


## Show wireles
uci show wireless 



