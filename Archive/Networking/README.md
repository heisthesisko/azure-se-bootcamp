# Azure Networking Workshop (GitHub-Ready)

This repository contains a **17-module, hands-on Azure Networking workshop** with fully working Bash deployment scripts, step-by-step Markdown guides, Mermaid diagrams, and sample app code (PHP + Python). Open in **VS Code** and run each module in order.

## Quick Start
1. Install/launch **VS Code**, open this folder.
2. In VS Code Terminal:
   ```bash
   bash scripts/login.sh
   cp config/env.sh config/env.local.sh && code config/env.local.sh   # edit values
   source config/env.local.sh
   ```
3. Run modules in sequence:
   ```bash
   bash infra/m01_vnet.sh
   bash infra/m02_nsg.sh
   # ...and so on
   ```

## Folder Structure
- `.vscode/` – tasks and recommendations
- `app/` – sample apps (`web` PHP, `ai` FastAPI)
- `assets/` – `diagrams` (Mermaid), `images`, `docs`
- `config/` – environment variables (`env.sh`)
- `db/` – sample PostgreSQL schema
- `infra/` – Azure CLI scripts (one per module)
- `scripts/` – helper scripts (login, cleanup)
- `system/` – VyOS example config

## Modules
| # | Module | Guide | Script |
|---|--------|-------|--------|
| 1 | Azure Virtual Network (VNet) | [Module01_VNet.md](Module01_VNet.md) | `infra/m01_vnet.sh` |
| 2 | Network Security Group (NSG) | [Module02_NSG.md](Module02_NSG.md) | `infra/m02_nsg.sh` |
| 3 | Azure Firewall | [Module03_AzureFirewall.md](Module03_AzureFirewall.md) | `infra/m03_firewall.sh` |
| 4 | Azure DDoS Protection | [Module04_DDoS.md](Module04_DDoS.md) | `infra/m04_ddos.sh` |
| 5 | VPN Gateway | [Module05_VPNGateway.md](Module05_VPNGateway.md) | `infra/m05_vpn_gateway.sh` |
| 6 | Private Link (Private Endpoint) | [Module06_PrivateLink.md](Module06_PrivateLink.md) | `infra/m06_private_link.sh` |
| 7 | NAT Gateway | [Module07_NATGateway.md](Module07_NATGateway.md) | `infra/m07_nat_gateway.sh` |
| 8 | Azure Load Balancer | [Module08_LoadBalancer.md](Module08_LoadBalancer.md) | `infra/m08_load_balancer.sh` |
| 9 | Application Gateway (WAF) | [Module09_AppGateway_WAF.md](Module09_AppGateway_WAF.md) | `infra/m09_app_gateway_waf.sh` |
| 10 | Azure Front Door | [Module10_FrontDoor.md](Module10_FrontDoor.md) | `infra/m10_front_door.sh` |
| 12 | Traffic Manager | [Module12_TrafficManager.md](Module12_TrafficManager.md) | `infra/m12_traffic_manager.sh` |
| 13 | Virtual WAN | [Module13_VirtualWAN.md](Module13_VirtualWAN.md) | `infra/m13_virtual_wan.sh` |
| 14 | Gateway Load Balancer | [Module14_GatewayLoadBalancer.md](Module14_GatewayLoadBalancer.md) | `infra/m14_gateway_lb.sh` |
| 15 | Azure DNS (Public & Private) | [Module15_AzureDNS.md](Module15_AzureDNS.md) | `infra/m15_azure_dns.sh` |
| 17 | ExpressRoute | [Module17_ExpressRoute.md](Module17_ExpressRoute.md) | `infra/m17_expressroute.sh` |

> Note: Module numbering follows the requested list (11 and 16 intentionally omitted).
> 

## Clean Up
```bash
bash scripts/cleanup.sh
```

## Disclaimer
Some advanced services (Front Door, Virtual WAN, ExpressRoute) may require specific Azure permissions, SKUs, or provider involvement. Scripts are crafted to be **working starting points**; adjust SKUs, names, and IPs to your environment.
