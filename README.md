# FinOps Year-End Audit: Reclaiming Budget from Orphaned Disks & Idle Private Endpoints

[![Pester Verification](https://img.shields.io/badge/pester-16%2F16%20passing-brightgreen)](tests/OrphanedHarvester.Tests.ps1)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Architecture Deep-Dive](https://img.shields.io/badge/blog-alerasoul.net-0a1128)](https://alerasoul.net/finops-orphaned-cloud-asset-harvester/)

> **Primary Governance Artefact:** Automated Orphaned Asset Harvester & Zero-Loss Deletion Matrix  
> **Accountable Service Owner:** Principal Azure Platform Architect & Cloud FinOps Lead  
> **Full Architectural Deep-Dive:** [https://alerasoul.net/finops-orphaned-cloud-asset-harvester/](https://alerasoul.net/finops-orphaned-cloud-asset-harvester/)

---

## Repository Layout (8 Files)

```text
├── .gitignore
├── LICENSE
├── README.md
├── config/retention-grace-period.json
├── docs/SNAPSHOT-RECLAMATION-SAFETY.md
├── queries/Arg-UnattachedDisks-NICs.kql
├── src/Test-OrphanedAssetReclamationGate.ps1
└── tests/OrphanedHarvester.Tests.ps1
```

## Quickstart & Offline Verification

```powershell
# 1. Execute the primary PowerShell 7 evaluator
pwsh -NoProfile -File ./src/Test-OrphanedAssetReclamationGate.ps1

# 2. Run the 16-test Pester verification contract
Invoke-Pester -Path ./tests/OrphanedHarvester.Tests.ps1 -Output Detailed
```

## License

Released under the [MIT License](LICENSE). Authored by **Shahrad Alerasoul** ([alerasoul.net](https://alerasoul.net)).
