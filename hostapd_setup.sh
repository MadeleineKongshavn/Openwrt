

## Changes done in /etc/config/wireless

/etc/config/wireless

option disabled '1'--> option disabled '0'

#change to:
config	wifi-device	'wl0'

#Set interface 
#Specifies the hardware mode, possible values are 11b for 2.4 GHz (used for legacy 11b only), 11g for 2.4 GHz (used for 802.11b, 802.11g and 802.11n) and 11a for 5 GHz (used for 802.11a, 802.11n and 802.11ac). Note that 11ng, 11na, 11n and 11ac are invalid options, this setting should largely be seen as controlling the frequency band.
option hwmode '11a' --> option hwmode '11g'

#default for openwrt RP4 is a setup with 5GH. we are changing and using 2.4GHZ
option channel '36' -> option channel '6'

#A complete wireless configuration contains at least one wifi-iface section per adapter to define a wireless network on
#top of the hardware. Some drivers support multiple wireless networks per device. A minimal example for a wifi-iface declaration is given below.

config	wifi-iface
	option	device		'wl0'
	option	network		'lan'
	option	mode		'ap'
	option	ssid		'OpenWrtAP'
	option	encryption	'psk2'
	option	key		'secret'

    wifi up wlan2; # WiFi Up: 
    wifi down wlan2. # WiFi down 




#NOTE FOR 5GHZ: If you have configured 5GHz Wi-Fi and have just enabled it, but the 5 GHz Wi-Fi does not seem to start up, consider 
#the following: If your device supports Wi-Fi channels > 100, your OpenWrt device first must scan for weather radar on these channels, before 
#you can actually use such channels for Wi-Fi. This may take 1-10 minutes onetime after first reboot depending on your Wi-Fi situation and 
#depending on the number of device-supported channels > 100. You may also experience 1 minute delay on each automatic channel change, as 
#the same scan delay is required for regulation compliance.

## Trying to start Hostapd
wifi up 


## If a problem with setup was found, the command 'logread' can be used to debug the problem.
logread



#If everything fails, consider removing the wireless configuration and re-configure it. 
rm -f /etc/config/wireless # Removing the wireless config file
wifi config # Re-creates a standard config file. 



## Wireless lan confiugred!
uci show wireless

echo
echo "----------------------------------------------"
echo "                AP configured!                "
echo "----------------------------------------------"
echo

hostnamectl  # Change hostname