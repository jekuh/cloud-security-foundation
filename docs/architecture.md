# Architecture

The repository uses the same core shape across clouds so you can compare platforms without relearning the whole layout each time.

## Shared Structure

- `bootstrap/`
  - remote state backend
  - CI/CD identity bootstrap
- `envs/dev` and `envs/prod`
  - isolated Terraform roots
  - separate state and variables
- `modules/`
  - reusable building blocks grouped by capability

## GCP Architecture In This Repo

The GCP implementation currently includes:

- `modules/project_services`
  - enables required APIs such as Compute Engine and Logging before resource creation
- `modules/identity`
  - application service account
- `modules/network`
  - VPC, public subnet, private subnet, router, and NAT
- `modules/storage`
  - application GCS bucket
- `modules/monitoring`
  - logs bucket plus Cloud Logging sink
- `modules/compute`
  - application VM and attached service account
- `modules/servers`
  - server VM, attached service account, and SSH firewall rule

## CI/CD Pattern

Terraform execution is manual and approval-gated:

- `terraform-plan`
- `terraform-apply`
- `terraform-destroy`

Each workflow is launched with `workflow_dispatch`, selects a cloud and environment, and is held behind a GitHub Environment approval gate.

## Design Intent

The project is opinionated toward learning secure cloud foundations through repetition:

- same repo structure across clouds
- same promotion model across environments
- same emphasis on remote state, reusable modules, and federation-based CI/CD
