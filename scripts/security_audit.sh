## **Script: `scripts/security_audit.sh`**

#!/bin/bash
# Qubes OS Security Audit Script
# Author: CySecKev

echo "=== Qubes OS Security Audit ==="

# Firewall check
echo "[*] Checking firewall..."
sudo qubes-firewall --status || echo "[!] Firewall check failed!"

# VPN check
VPN_IP=$(curl -s ifconfig.me)
if [ -n "$VPN_IP" ]; then
    echo "[*] Public IP detected: $VPN_IP"
else
    echo "[!] Unable to detect VPN connection"
fi

# Tor check
TOR_TEST=$(curl -s --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/)
if [[ "$TOR_TEST" == *"Congratulations"* ]]; then
    echo "[*] Tor proxy is active"
else
    echo "[!] Tor check failed"
fi

echo "=== Audit Complete ==="