# Cloud Security Foundation

Multi-cloud (AWS / Azure / GCP) **Cloud Security Foundation** built with:

- Infrastructure as Code (Terraform)
- Secure remote state
- OIDC-based CI/CD (no static credentials)
- Dev → Prod promotion workflow
- Security guardrails (linting + scanning)

Each cloud is fully independent with its own:

- environment structure
- reusable modules
- Makefile automation
- CI/CD pipelines
- bootstrap process

---

## Repository Layout

| Folder | Description |
|--------|-------------|
| `aws/`   | AWS secure foundation (fully implemented) |
| `azure/` | Azure foundation (scaffold) |
| `gcp/`   | GCP foundation (scaffold) |
| `docs/`  | Cross-cloud documentation |

---

## CI/CD Architecture (AWS)

### Workflow 1 — terraform-pr
Trigger: Pull Request  
Runs:
- terraform fmt
- terraform validate
- terraform plan (dev)
- security checks (tflint, tfsec)

No infrastructure changes are applied.

---

### Workflow 2 — terraform-apply
Trigger: Merge to `main`

1. Automatically applies **dev**
2. Requires manual approval to apply **prod** (GitHub Environment gate)

This enforces safe Dev → Prod promotion.

---

## Security Principles

- OIDC authentication (no AWS access keys)
- Separate state for dev/prod
- S3 backend with DynamoDB locking
- Encrypted storage by default
- IMDSv2 required on EC2
- Public access blocked on S3
- Terraform validation in CI before merge
- Branch protection enforced on `main`

---

## Quick Start

Choose a cloud folder and follow its README:

- `aws/README.md`
- `azure/README.md`
- `gcp/README.md`

---

## Roadmap

- Ransomware-resilient logging blueprint
- AWS Backup + Vault Lock
- GuardDuty + Security Hub
- Multi-account separation
- Policy-as-code (OPA / Checkov)

---

Built as a production-style Cloud Security Engineering lab.