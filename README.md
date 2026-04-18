# Cloud Security Foundation

Multi-cloud cloud security lab built with Terraform across AWS, Azure, and GCP.

The repository is organized so each cloud can stand on its own:

- reusable Terraform modules
- `dev` and `prod` environments
- bootstrap code for remote state and CI/CD identity
- Makefile-based local workflows
- shared documentation under `docs/`

## Repository Layout

| Folder | Description |
|--------|-------------|
| `aws/` | AWS secure foundation |
| `azure/` | Azure foundation scaffold |
| `gcp/` | GCP secure foundation |
| `docs/` | Cross-cloud architecture, controls, and learning notes |

## Current Status

### AWS

- Implemented foundation
- Remote state bootstrap
- OIDC-based CI/CD
- Dev and prod environments

### GCP

- Implemented foundation
- GCS remote state bootstrap
- Workload Identity Federation bootstrap for GitHub Actions
- Dev and prod environments
- VPC, subnets, NAT, service accounts, storage, logging, and Compute Engine

### Azure

- Structure scaffolded
- Planned to mirror the AWS and GCP layout

## Common Design

Each cloud follows the same high-level pattern:

- `bootstrap/`
  - state backend
  - CI/CD identity bootstrap
- `envs/dev` and `envs/prod`
  - isolated configuration and state
- `modules/`
  - reusable building blocks such as identity, network, compute, storage, and monitoring

## CI/CD Pattern

### Pull Request

- `terraform fmt`
- `terraform validate`
- `terraform plan` for `dev`
- `tflint`
- `tfsec`

No infrastructure is changed during PR validation.

### Merge To `main`

1. Apply `dev`
2. Gate `prod` behind approval

The intended authentication model is OIDC or workload federation rather than static credentials.

## Documentation

- [Shared architecture](./docs/architecture.md)
- [Security controls baseline](./docs/security-controls.md)
- [Roadmap](./docs/roadmap.md)
- [GCP from an AWS mindset](./docs/gcp-from-aws.md)

## Quick Start

Choose a cloud folder and follow its README:

- [AWS README](./aws/README.md)
- [Azure README](./azure/README.md)
- [GCP README](./gcp/README.md)

Built as a production-style cloud security engineering learning project.
