# Azure‑to‑Azure Linux (US West → East US)

```mermaid
flowchart LR
    subgraph Azure_West["Azure (US West) – Source"]
        VNetW[(VNet West)]
        SrcVM["Linux VM\nApache + PHP + PostgreSQL"]
        RSV["Recovery Services Vault"]
    end

    subgraph Azure_East["Azure (East US) – Target"]
        VNetE[(VNet East)]
        TgtVM["Linux VM (replicated target)"]
    end

    SrcVM --- VNetW
    RSV <-- A2A Replication --> SrcVM
    RSV -- "Create target (failover/test)" --> TgtVM
    TgtVM --- VNetE

    %% Styles
    classDef web fill:#e8f5e9,stroke:#2e7d32,stroke-width:1px;
    classDef vault fill:#ffebee,stroke:#c62828,stroke-width:1px;
    classDef net fill:#fafafa,stroke:#424242,stroke-width:1px;

    %% Apply classes (use 'class' instead of :::)
    class SrcVM,TgtVM web;
    class RSV vault;
    class VNetW,VNetE net;
```
