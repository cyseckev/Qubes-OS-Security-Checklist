# VPN & Tor Setup Guide

1. **Install VPN client** (WireGuard recommended)

2. **Configure VPN interfaces**
   - Use unique IP ranges per AppVM

3. **Test VPN connectivity**

4. **Configure Tor**
   - Use sys-whonix or isolated AppVM
   - Configure torrc for SOCKS5 proxy
   
5. **Verify Tor routing**

6. **Combine VPN + Tor**
   - Route AppVM traffic first through VPN, then Tor
   - Test leaks

```bash
   3. curl -s ifconfig.me
   5. curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/
   6. curl --interface <vpn_interface> --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/