# Module 1: Simple VM Replication

> [!IMPORTANT]
> Use mock ePHI only. Follow least privilege and TLS 1.2+.

**Start:**  
```bash
cp config/env.sample config/.env && code config/.env
bash infra/m01_simple_vm_replication.sh
```

**Diagrams**  
```mermaid
flowchart TB
  subgraph Primary
    APP[App VM]
    CACHE[(ASR Cache)]
  end
  subgraph Recovery
    RAPP[Recovery VM]
    VAULT[(Recovery Services Vault)]
  end
  APP --> CACHE --> VAULT --> RAPP

```
```mermaid
sequenceDiagram
  participant Eng as Student
  participant CLI as Azure CLI
  participant Vault as RSV
  participant VM as Source VM
  participant DR as Recovery VM
  Eng->>CLI: Create Policy/Mapping
  CLI->>Vault: PUT Policy
  Eng->>CLI: Enable Replication
  Vault-->>VM: Install extension
  Eng->>CLI: Failover
  Vault-->>DR: Create from recovery point

```

**Pros**: Cloud-native DR orchestration.  
**Cons**: Some features require on-prem appliance or portal flows.
