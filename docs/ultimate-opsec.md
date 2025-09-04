# Ultimate OPSEC Script for Qubes OS

## Overview
`ultimate-opsec.sh` is designed to enhance the operational security (OPSEC) of Qubes OS user VMs.  
It automates several critical privacy and security measures, ensuring VMs start with hardened settings without manual intervention.

## Purpose
- Randomize MAC addresses to prevent network tracking  
- Disable IPv6 for enhanced network privacy  
- Dynamically set DNS based on the active NetVM  
- Apply only to VMs with specific labels (`blue`, `red`, `yellow`, `violet`)  
- Fully silent and error-resistant  

This script is intended to be run **from dom0**, either manually or automatically at VM startup.

## Features
- **MAC Address Randomization**: Generates unique MAC addresses and avoids collisions with existing MACs  
- **IPv6 Disablement**: Disables IPv6 on the VM to prevent leaks  
- **Dynamic DNS**: Sets `/etc/resolv.conf` to the currently active NetVM IP  
- **Label-Based Execution**: Only affects user VMs with predefined labels  
- **Silent & Robust**: Errors are suppressed to avoid logs and interruptions  
- **Automatic Hook Ready**: Can be added as a Qubes start hook (`10-ultimate-opsec.sh`)  

## Usage

# 1️⃣ Place the script in dom0
chmod +x scripts/ultimate_opsec.sh

# 2️⃣ Run manually on a specific VM:
sudo ./scripts/ultimate_opsec.sh <VM_NAME>

# 3️⃣ Automatic execution at VM startup:

# Create autostart hook in dom0
sudo nano /etc/qubes-rpc/qubes.StartVM/10-ultimate_opsec.sh

# Contents of 10-ultimate_opsec.sh:

#!/bin/bash
##Run Ultimate OPSEC script for every user VM at startup
for VM in $(qvm-ls --raw-list | grep -v '^sys-' | grep -v '^dom0'); do
    /path/to/scripts/ultimate_opsec.sh "$VM"
done

# Make the hook executable
sudo chmod +x /etc/qubes-rpc/qubes.StartVM/10-ultimate_opsec.sh
