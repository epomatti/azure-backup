# Azure Recovery Services

Sandbox for Azure Recovery Services and Azure Backup.

## Deploy

Create the VM key:

```sh
mkdir -p .keys && ssh-keygen -f .keys/tmp_rsa
```

Set up the variables:

```sh
cp config/local.auto.tfvars .auto.tfvars
```

Deploye the resources:

```sh
terraform init
terraform apply -auto-approve
```

## Service Types

### Azure Recovery

Azure Recovery is oncerned about disaster recovery of Virtual Machines, as well as on-prem hypervisors.

Current default options is the [Enhanced Policy](https://learn.microsoft.com/en-us/azure/backup/backup-azure-vms-enhanced-policy?tabs=azure-portal).

Description for full backup:

- **Backup frequency** - Every 4 hour(s) starting 8:00 AM UTC for 12 Hour(s)
- **Instant restore** - Retain instant recovery snapshot(s) for 2 day(s)
- **Retention of daily backup point**- Retain backup taken every day for 30 Day(s)

Among other benefits of compatibility, the `Enhanced` policy overs 30 days over the `Standard` which is 5.

### Azure Backup

Takes care of managing copies over a long period of time for various Azure resources.

## Managed Disk Snapshots

Managed Disk Snapshots are a separate resource and are managed independently. For this project an additional data disk is attached.

Create a snapshot quickly by using the CLI:

```sh
az snapshot create -g rg-litware-default -n vm-litware --source osdisk-litware --sku Standard_LRS
```

Further control can be applied, such as setting the snapshot type:

```sh
--incremental false|true
```

Deleting it:

```sh
az snapshot delete -g rg-litware-default -n vm-litware
```
