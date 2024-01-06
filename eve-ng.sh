#!/bin/bash

# Put IOL images and key gen script in bucket folder named "images"
# Otherwise amend the lines 23-29 accordingly 
# Script assumes eve_ng_bucket/images/ path for files needed for IOL 
# ./eveng-init-setup eve_ng_bucket

echo
echo "-[INFO]- Configuring SSH root login ..."
echo "---------------------------------------"
printf "PermitRootLogin = yes\nPasswordAuthentication = yes\n"
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo
echo "-[INFO]- Restarting SSHD..."
service sshd restart
sleep 5

# echo
# echo "-[INFO]- Copying images from local to /bucket/images ..."
# echo "------------------------------------------------------"

echo
echo "-[INFO]- Copying images from bucket to /tmp/images ..."
echo "------------------------------------------------------"


gsutil cp -r gs:/$1/* /tmp/
   
cd /opt/unetlab/addons/iol/bin/
chmod +x *.py
chmod +x *.bin
mv /tmp/images/* .
rm -rf /tmp/images
   
key=$(python3 CiscoIOUKeygen.py 2>&1)
   
echo $key
echo 
echo "-[INFO]- Added license to iourc ..."
echo
echo '[license]' > /opt/unetlab/addons/iol/bin/iourc
echo '[license] eve-lab = 0654d2df5c259d40;' >> $HOME/.iourc
echo $key';' >> /opt/unetlab/addons/iol/bin/iourc
cat /opt/unetlab/addons/iol/bin/iourc
cd

sleep 5
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions

echo "-[INFO]- Configure IP address pnet9"
echo "-----------------------------------"
ip address add 198.18.18.1/24 dev pnet9
echo
echo "-[INFO]- Configure NAT pnet0"
echo "----------------------------"
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o pnet0 -s 198.18.18.0/24 -j MASQUERADE
echo
echo "-[INFO]- Install DHCP Server"
echo "----------------------------"
apt-get update -y
apt-get install isc-dhcp-server -y

echo
echo "-[INFO]- Configure DHCP Server"
echo "------------------------------"
echo
echo 'sed -i "s/INTERFACES=/INTERFACES="pnet9"/" /etc/default/isc-dhcp-server'
sed -i 's/INTERFACES=/INTERFACES="pnet9"/' /etc/default/isc-dhcp-server
echo
echo 'sed -i "s/#authoritative;/authoritative;/" /etc/dhcp/dhcpd.conf'
sed -i 's/#authoritative;/authoritative;/' /etc/dhcp/dhcpd.conf 
echo

match='authoritative;'
insert='# EVE-NG NAT Interface\
subnet 198.18.18.0 netmask 255.255.255.0 {\
        range 198.18.18.1 198.18.18.100;\
        interface pnet9;\
        default-lease-time 600;\
        max-lease-time 7200;\
        option domain-name-servers 8.8.8.8;\
        option broadcast-address 198.18.18.255;\
        option subnet-mask 255.255.255.0;\
        option routers 198.18.18.1;\
}'

sed -i "/$match/ a $insert" /etc/dhcp/dhcpd.conf 

echo "-[INFO]- Restart DHCP Server"
echo "----------------------------"

systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server
echo
echo "-[INFO]- DHCP server lease file"
echo "-------------------------------"
echo "/var/lib/dhcp/dhcpd.leases" 
#cat /var/lib/dhcp/dhcpd.leases
echo
echo "Use below egrep command to check DHCP lease"
echo "-------------------------------------------"
echo "egrep -a 'lease|hostname' /var/lib/dhcp/dhcpd.leases | sort | uniq"
echo

sleep 5
echo "-[INFO]- Installing Python venv package ..."
echo "-------------------------------------------"
sleep 3
apt-get install python3-venv -y

echo "-[INFO]- Creating Python3 venv named 'workspace'"
echo "------------------------------------------------"
python3 -m venv workspace
source workspace/bin/activate
pip install --upgrade pip
pip install netmiko==2.4.2
pip install paramiko
pip install ncclient
pip install xmltodict
deactivate
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions
echo
echo "Check out the workspace venv for Python scripts"
echo "All Done! :)"
