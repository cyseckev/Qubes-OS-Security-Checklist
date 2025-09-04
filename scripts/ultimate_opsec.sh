#!/bin/bash
# **Ultimate OPSEC** Hook Script for Qubes OS
# Version: 1.0
# Author: CySecKev
#
# Enhances operational security for label-marked VMs.
# Features:
#   - MAC address randomization with collision avoidance
#   - IPv6 disabled for network privacy
#   - Dynamic DNS based on active NetVM IP
#   - Label-based selective execution (blue, red, yellow, violet)
#   - Fully silent, error-resistant
#   - Automatic execution at VM startup

# --- 1️⃣ Gather all user VMs ---
VM_LIST=$(qvm-ls --raw-list --no-color | grep -v '^sys-' | grep -v '^dom0$')

# --- 2️⃣ Function to generate a unique MAC address ---
generate_unique_mac() {
    local NETVM="$1"
    local existing_macs
    existing_macs=$(qvm-prefs "$NETVM" vms 2>/dev/null | xargs -n1 -I{} qvm-prefs {} mac 2>/dev/null)
    local mac
    while true; do
        RANDOM_BYTES=$(hexdump -n3 -e '/3 ":%02X"' /dev/urandom)
        mac="52:54:00${RANDOM_BYTES}"
        if ! echo "$existing_macs" | grep -iq "$mac"; then
            echo "$mac"
            return 0
        fi
    done
}

# --- 3️⃣ Loop through all VMs ---
for VM_NAME in $VM_LIST; do
    # Skip if VM doesn't exist
    qvm-prefs "$VM_NAME" >/dev/null 2>&1 || continue

    # Check label
    VM_LABEL=$(qvm-prefs "$VM_NAME" label 2>/dev/null)
    if [[ "$VM_LABEL" != "blue" && "$VM_LABEL" != "red" && "$VM_LABEL" != "yellow" && "$VM_LABEL" != "violet" ]]; then
        continue
    fi

    # --- 3a️⃣ MAC randomization ---
    NETVM=$(qvm-prefs "$VM_NAME" netvm 2>/dev/null)
    if [[ -n "$NETVM" ]]; then
        NEW_MAC=$(generate_unique_mac "$NETVM")
    else
        RANDOM_BYTES=$(hexdump -n3 -e '/3 ":%02X"' /dev/urandom)
        NEW_MAC="52:54:00${RANDOM_BYTES}"
    fi
    qvm-prefs "$VM_NAME" mac "$NEW_MAC" 2>/dev/null || true

    # --- 3b️⃣ Disable IPv6 ---
    qrexec-run "$VM_NAME" "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1" 2>/dev/null || true
    qrexec-run "$VM_NAME" "sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1" 2>/dev/null || true

    # --- 3c️⃣ Dynamic DNS ---
    if [[ -n "$NETVM" ]]; then
        NETVM_IPS=$(qvm-prefs "$NETVM" ip 2>/dev/null | awk '{print $1}' | grep -E '^(10\.|172\.|192\.168\.)')
        ACTIVE_IP=""
        for ip in $NETVM_IPS; do
            ping -c 1 -W 1 "$ip" >/dev/null 2>&1
            if [[ $? -eq 0 ]]; then
                ACTIVE_IP="$ip"
                break
            fi
        done
        if [[ -n "$ACTIVE_IP" ]]; then
            qrexec-run "$VM_NAME" "sudo bash -c 'echo \"nameserver $ACTIVE_IP\" > /etc/resolv.conf'" 2>/dev/null || true
        fi
    fi
done

exit 0
