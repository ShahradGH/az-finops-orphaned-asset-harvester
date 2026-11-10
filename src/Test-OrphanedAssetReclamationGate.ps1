# Test-OrphanedAssetReclamationGate.ps1
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [PSCustomObject]$AssetRecord
)

$ErrorActionPreference = 'Stop'

# 1. Hard Protection: Never touch Azure Site Recovery (ASR) replicas or active Kubernetes PVCs
if ($AssetRecord.ResourceName -match '^(?i)ASR-' -or
    ($AssetRecord.Tags -and $AssetRecord.Tags.PSObject.Properties['ASR-ReplicaDisk']) -or
    ($AssetRecord.Tags -and $AssetRecord.Tags.PSObject.Properties['kubernetes.io-created-for-pvc-name'])) {
    return [PSCustomObject]@{
        ResourceId = $AssetRecord.ResourceId
        Action     = 'PROTECT_DR_REPLICA_OR_K8S_PVC'
        PurgeAllowed = $false
    }
}

# 2. Dangling Private Endpoint with Disconnected or Deleted Target Resource
if ($AssetRecord.ResourceType -eq 'Microsoft.Network/privateEndpoints' -and $AssetRecord.ConnectionState -eq 'Disconnected') {
    return [PSCustomObject]@{
        ResourceId   = $AssetRecord.ResourceId
        Action       = 'PURGE_DANGLING_PRIVATE_ENDPOINT_AND_DNS_RECORD'
        PurgeAllowed = $true
    }
}

# 3. Unattached Managed Disk (> 30 days): Require Verified Archive Blob Checksum Before Deletion
if ($AssetRecord.ResourceType -eq 'Microsoft.Compute/disks' -and $AssetRecord.DiskState -eq 'Unattached' -and $AssetRecord.UnattachedDays -ge 30) {
    if (-not $AssetRecord.ArchiveBlobSha256Verified) {
        return [PSCustomObject]@{
            ResourceId   = $AssetRecord.ResourceId
            Action       = 'VETO_DELETE_UNTIL_ARCHIVE_SNAPSHOT_VERIFIED'
            PurgeAllowed = $false
        }
    }
    return [PSCustomObject]@{
        ResourceId   = $AssetRecord.ResourceId
        Action       = 'DELETE_UNATTACHED_DISK_AFTER_COLD_ARCHIVE'
        PurgeAllowed = $true
    }
}

return [PSCustomObject]@{
    ResourceId   = $AssetRecord.ResourceId
    Action       = 'RETAIN_WITHIN_GRACE_WINDOW'
    PurgeAllowed = $false
}