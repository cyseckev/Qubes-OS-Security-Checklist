# 🔐 Qubes-OS Security Checklist

> Maximum anonymity & OPSEC hardening guide for Qubes OS environments – **CySecKev**

---

## 🛡️ Features
- Secure VM isolation & workflow  
- Network hardening with VPN/TOR chains  
- Firewall & AppVM configuration scripts  
- OPSEC best practices & anonymized workflows

---

## 🛠️ Badges
![Linux](https://img.shields.io/badge/Linux-Debian-blue?logo=linux)
![Qubes](https://img.shields.io/badge/Qubes_OS-2E3440?logo=qubes-os&logoColor=white)
![VPN](https://img.shields.io/badge/VPN-Secure-green)
![TOR](https://img.shields.io/badge/TOR-Anonymity-green)

---

## 📁 Folder Structure
- docs/ → Step-by-step guides
- scripts/ → Security audit scripts
- README.md → This file
- LICENCE → MIT-Licence

---

## Updates 

## 🛠️ Added Script: `ultimate_opsec.sh`

**Purpose:**  
Enhances Qubes OS operational security by automatically randomizing MAC addresses, disabling IPv6, and dynamically setting DNS to the currently active NetVM.  
Only applies to VMs with labels **blue, red, yellow, violet**, and runs silently at each VM start.

**Features:**
- MAC address randomization with collision avoidance
- IPv6 disabled for network privacy
- Dynamic DNS based on active NetVM IP
- Label-based selective execution
- Fully silent and error-resistant
- Designed for automatic execution at VM startup

---

## 🚀 Usage
```bash
bash scripts/security_audit.sh

## 📌 Notes
- Continuous updates recommended
- Designed for research & personal security
- Not for commercial use


**ultimate_opsec.sh**

# 1️⃣ Place the script in dom0
chmod +x scripts/ultimate_opsec.sh

# 2️⃣ Run manually on a specific VM:
sudo ./scripts/ultimate_opsec.sh <VM_NAME>

# 3️⃣ Automatic execution at VM startup:

# Create autostart hook in dom0
sudo nano /etc/qubes-rpc/qubes.StartVM/10-ultimate_opsec.sh


Contents of 10-ultimate_opsec.sh:
#!/bin/bash
# Run Ultimate OPSEC script for every user VM at startup
for VM in $(qvm-ls --raw-list | grep -v '^sys-' | grep -v '^dom0'); do
    /path/to/scripts/ultimate_opsec.sh "$VM"
done


# Make the hook executable
sudo chmod +x /etc/qubes-rpc/qubes.StartVM/10-ultimate_opsec.sh
