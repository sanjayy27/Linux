#Wifidriver
#https://github.com/tomaspinho/rtl8821ce
#https://forums.linuxmint.com/viewtopic.php?t=394684

#!/bin/bash

# Check if the script is run with sudo or as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi

# Step 1: Update and install necessary packages
echo "Step 1: Installing required packages"
sudo apt update && sudo apt install -y bc module-assistant build-essential dkms git

# Step 2: Re-run the update and install commands for redundancy
echo "Step 2: Re-running package installation"
sudo apt update && sudo apt install -y bc module-assistant build-essential dkms git

# Step 3: Remove existing rtl8821ce-dkms driver if it is installed
echo "Step 3: Removing existing rtl8821ce-dkms driver, if present"
if dkms status | grep -q "rtl8821ce"; then
  sudo dkms remove rtl8821ce/1.0 --all
else
  echo "rtl8821ce-dkms not found, proceeding"
fi

# Step 4: Change to the rtl8821ce driver source directory
echo "Step 4: Navigating to the rtl8821ce source directory"
cd rtl8821ce || { echo "Failed to navigate to rtl8821ce directory"; exit 1; }

# Step 5: Prepare module-assistant for building drivers
echo "Step 5: Preparing module-assistant"
sudo m-a prepare

# Step 6: Install the new driver using the dkms-install script
echo "Step 6: Installing the driver"
sudo ./dkms-install.sh

# Step 7: Re-run the driver installation for redundancy
echo "Step 7: Re-running the driver installation"
sudo ./dkms-install.sh

# Step 8: Open the blacklist configuration for editing
echo "Step 8: Opening blacklist.conf to add a new blacklist rule"
# Here, you can use sed to automate the editing process
sudo bash -c 'echo "blacklist rtw88_8821ce" >> /etc/modprobe.d/blacklist.conf'

echo "Script completed successfully!"


