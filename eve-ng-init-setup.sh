#!/bin/bash

# Check if python3 is installed
if ! [ -x "$(command -v python3)" ]; then
  echo "Error: python3 is not installed. Please install it."
  exit 1
fi

echo "Sleeping for 5 seconds..."
sleep 5

echo "[INFO] Installing/upgrading pip..."
echo "---------------------------------"
sudo apt-get update
sudo apt-get install python3-pip
python3 -m pip install --upgrade pip -y

echo "[INFO] Installing python3-venv package..."
echo "---------------------------------------"
apt-get update
apt-get install python3-venv -y

echo "[INFO] Creating Python3 venv named 'workspace'..."
echo "----------------------------------------------"
python3 -m venv workspace

echo "[INFO] Activating the 'workspace' venv..."
echo "----------------------------------------"
source workspace/bin/activate

echo "[INFO] Upgrading pip in the venv..."
echo "---------------------------------"
pip install --upgrade pip -y

echo "[INFO] Installing Python packages..."
echo "-----------------------------------"
pip install netmiko==2.4.2 paramiko ncclient xmltodict

echo "[INFO] Deactivating the venv..."
echo "-----------------------------"
deactivate

echo "[INFO] Fixing permissions..."
echo "[INFO] $kvm_family = file_get_contents("/opt/unetlab/platform");"
echo "-----------------------------"

echo "[INFO] Editting the platform...".

dmesg | grep -i cpu | grep -i -e intel -e amd

echo "[INFO] Fixing permissions..."if you get an output line with the word "Intel"

echo "intel" > /opt/unetlab/platform

echo "[INFO] Fixing permissions..."if you get an output line with the word "amd"

echo "amd" > /opt/unetlab/platform

echo "--------------------------"
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions

echo "Done!"
echo "=============================================="
