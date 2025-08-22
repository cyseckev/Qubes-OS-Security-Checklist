# Network Configuration Guide

- **sys-net** → generic internet access
- **sys-whonix** → Tor-only traffic
- **Isolated AppVMs** → separate network types per VM
- **Firewall rules** → per AppVM using `qubes-firewall`
- **Routing** → VPN interfaces first, Tor interfaces second
- **DNS leakage prevention** → verify with:
```bash
dig +short @1.1.1.1 whoami.cloudflare
resolvectl status
