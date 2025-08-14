
# Azure Storage Networking Workshop (Hands-On)

Zero-Azure-experience friendly, 20 modules, all Bash + Azure CLI. Start with `modules/Module01-AzureStorageAccount.md` and run scripts from `scripts/`.

> [!IMPORTANT]
> You own any Azure costs. Use `scripts/99_cleanup.sh` when finished.

## Quickstart
```bash
az login
cp config/env.sample config/env.sh
# edit config/env.sh
bash scripts/00_prereqs.sh
bash scripts/01_storage_account.sh
```
