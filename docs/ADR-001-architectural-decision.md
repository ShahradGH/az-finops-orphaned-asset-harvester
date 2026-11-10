# ADR-001: FinOps Year-End Audit: Reclaiming Budget from Orphaned Disks & Idle Private Endpoints

## Status
Accepted

## Service Owner & Sign-Off Authority
Principal Azure Platform Architect & Cloud FinOps Lead

## Dominant Artefact
Automated Orphaned Asset Harvester & Zero-Loss Deletion Matrix

## Decision & Refusal Boundary
All production state mutations must pass deterministic pre-flight policy evaluation in `src/Test-OrphanedAssetReclamationGate.ps1` and satisfy the 16-test Pester verification contract in `tests/Boundary-Verification.Tests.ps1` before execution.
