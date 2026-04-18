# Security Controls Baseline

This repository is a learning project, but it still applies a baseline set of security controls across clouds where practical.

## Shared Controls

- Terraform remote state is stored outside the local machine
- CI runs `terraform fmt`, `terraform validate`, `tflint`, and `tfsec`
- environments are separated into `dev` and `prod`
- reusable modules keep infrastructure changes more consistent
- OIDC or workload federation is preferred over static credentials

## GCP Controls Present Today

- Terraform state is stored in a GCS bucket
- GCS buckets use public access prevention
- GCS buckets use versioning
- Compute Engine instances enable OS Login
- the project enables required APIs in Terraform before creating dependent resources
- GitHub CI/CD can use Workload Identity Federation instead of service account keys

## GCP Gaps To Improve

- SSH is currently open to `0.0.0.0/0` for learning convenience
- VM instances currently receive ephemeral public IPs
- customer-managed encryption is optional for the application bucket and not yet applied to compute disks
- retention, lifecycle, and logging hardening can be expanded
- CI/CD roles can be reduced further toward least privilege
