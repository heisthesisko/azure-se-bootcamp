# Overall Architecture – ASR Workshop

```mermaid
flowchart TB
    %% On‑prem fabrics
    subgraph VMware["On‑Prem VMware"]
        LW[linux-web]:::web
        LD[linux-db]:::db
        ESXi[ESXi]:::hv
        OVA[ASR Appliance]:::agent
        LW --- LD
        LW --- ESXi
        LD --- ESXi
        ESXi --- OVA
    end

    subgraph HyperV["On‑Prem Hyper‑V"]
        WW[win-web]:::web
        WD[win-db]:::db
        HV[Hyper‑V]:::hv
        Prov[ASR Provider]:::agent
        WW --- WD
        WW --- HV
        WD --- HV
        HV --- Prov
    end

    subgraph AzureWest["Azure – West US"]
        VNW[(VNet West)]:::net
        RSV[Recovery Services Vault]:::vault
        A2A_SRC[Linux VM (A2A source)]:::web
        AZ_W_LW[Azure VM linux-web]:::web
        AZ_W_LD[Azure VM linux-db]:::db
        AZ_W_WW[Azure VM win-web]:::web
        AZ_W_WD[Azure VM win-db]:::db
    end

    subgraph AzureEast["Azure – East US"]
        VNE[(VNet East)]:::net
        A2A_TGT[Linux VM (A2A target)]:::web
    end

    %% Replication flows
    OVA -- "VM discovery + replication" --> RSV
    Prov -- "Host registration + replication" --> RSV
    RSV -- "Create/maintain replicated items" --> AZ_W_LW
    RSV -- "Create/maintain replicated items" --> AZ_W_LD
    RSV -- "Create/maintain replicated items" --> AZ_W_WW
    RSV -- "Create/maintain replicated items" --> AZ_W_WD
    A2A_SRC <-- "A2A" --> RSV
    RSV -- "Failover/Test" --> A2A_TGT

    %% Networks
    VNW --- RSV
    VNE --- A2A_TGT

    classDef web fill:#e8f5e9,stroke:#2e7d32,stroke-width:1px;
    classDef db fill:#e3f2fd,stroke:#1565c0,stroke-width:1px;
    classDef hv fill:#f3e5f5,stroke:#6a1b9a,stroke-width:1px;
    classDef agent fill:#fff3e0,stroke:#ef6c00,stroke-width:1px;
    classDef vault fill:#ffebee,stroke:#c62828,stroke-width:1px;
    classDef net fill:#fafafa,stroke:#424242,stroke-dasharray:3 3;
```
