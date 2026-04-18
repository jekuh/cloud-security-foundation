# GCP Secure Foundation

Independent GCP folder mirroring AWS structure.

## Architecture Overview

### Environments

- `envs/dev`
- `envs/prod`

Each environment:

- Has its own remote state in GCS
- Uses separate Terraform state keys
- Is promoted via CI/CD

## Infrastructure Components (Dev)

- Dedicated VPC with public/private subnets
- Cloud NAT for private subnet outbound
- Service Accounts for identity
- GCS application bucket
  - Versioning enabled
  - Encryption enabled
  - Public access blocked
- Cloud Logging sink to GCS
- Compute Engine instances
  - OS Login enabled
  - Service accounts attached

## Remote State

- GCS backend
- Separate state keys per environment
- Encryption enabled

## CI/CD Pipeline

### terraform-pr (Pull Request)

- fmt
- validate
- plan (dev only)
- tflint
- tfsec

No infrastructure is modified.

### terraform-apply (Merge to main)

1. Automatically applies changes to **dev**
2. Requires manual approval to apply **prod**

Authentication uses:

- GitHub OIDC → Workload Identity Federation → GCP Service Account
- No long-lived GCP credentials

## Quick Start (Local)

### 1) Bootstrap Remote State (run once)

From `gcp/`:

```bash
make bootstrap-state \
  STATE_BUCKET=mb-terraform-gcp-state-2026 \
  PROJECT_ID=your-gcp-project-id \
  REGION=us-central1
```

### 2) Bootstrap OIDC (run once)

```bash
make bootstrap-oidc \
  GITHUB_ORG=your-github-org \
  GITHUB_REPO=cloud-security-foundation \
  PROJECT_ID=your-gcp-project-id \
  REGION=us-central1
```

### 3) Deploy Dev Environment

Update `envs/dev/terraform.tfvars` with your project details, then:

```bash
make init ENV=dev
make plan ENV=dev
make apply ENV=dev
```

## Security Principles

- Workload Identity Federation (no service account keys)
- Remote state encrypted + access controlled
- GCS/Compute: encryption by default
- Public access blocked on GCS
- OS Login on Compute instances
- Terraform validation in CI before merge
- Branch protection enforced on `main`
