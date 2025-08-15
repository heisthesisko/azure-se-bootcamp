# On-Prem Hyper-V & VyOS Notes (Training)
- Create three VMs on Hyper-V: PostgreSQL (Ubuntu/Rocky), Apache/PHP (Ubuntu/Rocky), AI Model Server (Ubuntu/Rocky).
- Deploy VyOS as the edge router/firewall (public IP required) for S2S to Azure VPN Gateway.
- Ensure your on-prem LAN range does not overlap with Azure VNet CIDR (default: 10.10.0.0/16).
- Open outbound UDP 500/4500 to Azure for IPsec/IKE.
- Apply `scripts/vyos_s2s_config.txt` replacing placeholders.
