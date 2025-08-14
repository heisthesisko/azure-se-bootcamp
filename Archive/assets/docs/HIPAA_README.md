# HIPAA-Oriented Notes (Training Context)

- Treat all sample patient data as **synthetic** (no real PHI). 
- Use **encryption at rest** (Azure-managed keys by default) and **in transit** (TLS).
- Prefer **private endpoints**, **NSGs**, and **Azure Firewall**; avoid public IPs for PHI workloads.
- Use **Azure Monitor** and **Log Analytics** for audit logs; configure retention per policy.
- Ensure **least privilege** (RBAC), **MFA**, and **Privileged Identity Management** for admin ops.
- Confirm your organization’s **BAA** with Microsoft before placing PHI in Azure.
