#!/bin/bash
echo "Stopping network manager ..."
service network-manager stop
rfkill unblock wlan
echo "restart wireless interface ..."
ifconfig wlan0 up
echo "Starting hostapd ..."
/usr/lib/mana-toolkit/hostapd -dd -B /etc/hostapd/hostapd.conf
sleep 5
echo "Configuring wireless interface ..."
ifconfig wlan0 10.0.0.1 netmask 255.255.255.0
route add -net 10.0.0.0 netmask 255.255.255.0 gw 10.0.0.1
echo "Starting dnsmasq as DHCP server ..."
dnsmasq
echo "Stopping firewall and allowing everyone ..."
echo '1' > /proc/sys/net/ipv4/ip_forward
iptables --policy INPUT ACCEPT
iptables --policy FORWARD ACCEPT
iptables --policy OUTPUT ACCEPT
iptables -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j REDIRECT --to-ports 8080
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 443 -j REDIRECT --to-ports 8080
echo "Hit enter to kill me"
read
pkill dhcpd
pkill hostapd
pkill dnsmasq
iptables -t nat -F

