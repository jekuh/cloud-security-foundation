# GCP Secure Foundation

This folder contains a Terraform-based GCP foundation with separate `dev` and `prod` environments, GCS remote state, GitHub OIDC bootstrap, and reusable modules for identity, networking, storage, monitoring, and compute.

If you come from AWS, read [docs/gcp-from-aws.md](../docs/gcp-from-aws.md) after this README.

## What This Deploys

The current `dev` environment creates:

- project service enablement for required APIs
- one application service account
- one Compute Engine service account
- one server service account
- one VPC
- one public subnet
- one private subnet
- one Cloud Router
- one Cloud NAT
- one application GCS bucket
- one logs GCS bucket
- one Cloud Logging sink writing instance logs to GCS
- one Compute Engine instance named `mb-dev-instance`
- one Compute Engine instance named `mb-dev-server`
- one firewall rule allowing SSH from `0.0.0.0/0`

## Folder Structure

| Path | Purpose |
|------|---------|
| `bootstrap/state` | Creates the GCS bucket used for Terraform remote state |
| `bootstrap/oidc` | Creates Workload Identity Federation resources for GitHub Actions |
| `envs/dev` | Development environment root module |
| `envs/prod` | Production environment root module |
| `modules/identity` | App service account |
| `modules/project_services` | Enables required GCP APIs before dependent resources |
| `modules/network` | VPC, subnets, router, and NAT |
| `modules/storage` | Application GCS bucket |
| `modules/monitoring` | Logs bucket and logging sink |
| `modules/compute` | App VM and service account |
| `modules/servers` | Server VM, service account, and SSH firewall rule |

## Resource Mapping For AWS Users

| AWS concept | GCP equivalent in this project |
|------------|--------------------------------|
| VPC | VPC network |
| Public subnet | Subnetwork with instances that can receive external IPs |
| Private subnet + NAT Gateway | Private subnetwork + Cloud Router + Cloud NAT |
| IAM role for workload | Service account attached to a VM |
| S3 bucket | GCS bucket |
| CloudWatch Logs destination | Cloud Logging sink |
| EC2 instance | Compute Engine instance |
| OIDC from GitHub to IAM role | GitHub OIDC to Workload Identity Federation and service account impersonation |

## Security Baseline

- GCS buckets have public access prevention enabled
- GCS buckets have versioning enabled
- OS Login is enabled on Compute Engine instances
- Terraform state is stored remotely in GCS
- GitHub CI/CD uses Workload Identity Federation rather than static keys
- Required GCP APIs are enabled in Terraform before dependent resources are created

## Important GCP Notes

- GCS bucket names are globally unique across all GCP customers, not just within one project.
- Some APIs, especially `compute.googleapis.com`, may need a few minutes to propagate after first enablement.
- The current logs bucket name includes the project ID to avoid global bucket name collisions.
- The current VMs receive ephemeral public IPs because each instance declares an `access_config` block.
- The current SSH firewall rule is wide open for learning purposes and should be restricted before treating this as production-ready.

## Quick Start

### 1. Set your variables

Update [envs/dev/terraform.tfvars](./envs/dev/terraform.tfvars) with your project values.

Example:

```hcl
environment = "dev"
name_prefix = "mb"
project_id  = "your-gcp-project-id"
region      = "europe-west6"
```

Optional:

- `kms_key_name` if you want the application bucket encrypted with a customer-managed KMS key

### 2. Bootstrap remote state

From `gcp/`:

```bash
make bootstrap-state \
  STATE_BUCKET=your-terraform-state-bucket \
  PROJECT_ID=your-gcp-project-id \
  REGION=europe-west6
```

Then update [envs/dev/backend.hcl](./envs/dev/backend.hcl) and [envs/prod/backend.hcl](./envs/prod/backend.hcl) to use that bucket.

### 3. Bootstrap GitHub OIDC

```bash
make bootstrap-oidc \
  GITHUB_ORG=your-github-org \
  GITHUB_REPO=cloud-security-foundation \
  PROJECT_ID=your-gcp-project-id \
  REGION=europe-west6
```

This creates:

- a workload identity pool
- a GitHub OIDC provider
- a GitHub Actions service account
- IAM bindings so GitHub Actions can impersonate that service account

### 4. Deploy the environment

```bash
make init ENV=dev
make plan ENV=dev
make apply ENV=dev
```

If the first apply stops after enabling APIs, wait a few minutes and rerun `make apply ENV=dev`.

## Helpful Commands

```bash
make fmt
make validate ENV=dev
make plan ENV=dev
make apply ENV=dev
make output ENV=dev
make destroy ENV=dev
```

## Example Outputs

A successful `dev` apply should produce outputs similar to:

- `instance_name`
- `log_sink_name`
- `service_account_email`
- `storage_bucket_name`
- `subnet_id`
- `vpc_id`

## Next Learning Steps

After you are comfortable with this baseline, useful next improvements are:

- restrict SSH source ranges
- remove public IPs from VMs that do not need them
- add customer-managed encryption keys for buckets and disks
- add flow logs and stronger logging retention controls
- reduce CI/CD permissions to least privilege
