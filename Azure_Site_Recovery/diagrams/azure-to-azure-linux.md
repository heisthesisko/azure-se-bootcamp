# Azure‑to‑Azure Linux (US West → East US)

```mermaid
flowchart LR
    subgraph Azure_West["Azure (US West) – Source"]
        VNetW[(VNet West)]:::net
        SrcVM[Linux VM<br>Apache + PHP + PostgreSQL]:::web
        RSV[Recovery Services Vault]:::vault
    end

    subgraph Azure_East["Azure (East US) – Target"]
        VNetE[(VNet East)]:::net
        TgtVM[Linux VM (replicated target)]:::web
    end

    SrcVM --- VNetW
    RSV <-- "A2A Replication" --> SrcVM
    RSV -- "Create target (failover/test)" --> TgtVM
    TgtVM --- VNetE

    classDef web fill:#e8f5e9,stroke:#2e7d32,stroke-width:1px;
    classDef vault fill:#ffebee,stroke:#c62828,stroke-width:1px;
    classDef net fill:#fafafa,stroke:#424242,stroke-dasharray:3 3;
```
