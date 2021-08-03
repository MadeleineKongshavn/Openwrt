#Set the IP address for this device. 


## 193.156.3.73/25
## 193.156.3.74/25
## 193.156.3.75/25


echo "Current setup!"
ifconfig

echo "" > /etc/config/network

echo "config interface 'loopback'"                                 >> /etc/config/network
echo "    option ifname 'lo'"                                  >> /etc/config/network
echo "    option proto 'static'"                               >> /etc/config/network
echo "    option ipaddr '127.0.0.1'"                           >> /etc/config/network
echo "    option netmask '255.0.0.0'"                          >> /etc/config/network
echo ""                                                     >> /etc/config/network

echo "config globals 'globals'"                                    >> /etc/config/network
echo "    option ula_prefix 'fdd7:b382:9259::/48'"             >> /etc/config/network
                                                            >> /etc/config/network
echo "config interface 'lan'"                                      >> /etc/config/network
echo "        option ifname 'eth0'"                                >> /etc/config/network
echo "        option proto 'static'"                               >> /etc/config/network
echo "        option ipaddr '193.156.3.74'"                        >> /etc/config/network
echo "       option gateway '193.156.3.1'"                        >> /etc/config/network
echo "        option netmask '255.255.255.0'"                      >> /etc/config/network
echo "        option dns '129.240.2.3'"                            >> /etc/config/network
echo "        option ip6assign '60'"                               >> /etc/config/network

echo "\n\nAfter setup!"
ifconfig
