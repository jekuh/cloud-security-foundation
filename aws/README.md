# AWS Secure Foundation (MVP)

A production-style AWS foundation built using Terraform and secure CI/CD practices.

This environment implements a secure-by-default infrastructure baseline with Dev → Prod promotion workflow.

---

## Architecture Overview

### Environments
- `envs/dev`
- `envs/prod`

Each environment:
- Has its own remote state
- Uses separate Terraform state keys
- Is promoted via CI/CD

---

## Infrastructure Components (Dev)

- Dedicated VPC
- Public subnet + Internet Gateway
- Route tables
- IAM role
- S3 application bucket
  - Versioning enabled
  - Encryption enabled
  - Public access blocked
- CloudWatch log group
- EC2 instance
  - IMDSv2 enforced
  - Root volume encrypted

---

## Remote State

- S3 backend
- DynamoDB state locking
- Separate state keys per environment
- Encryption enabled

---

## CI/CD Pipeline

### terraform-pr (Pull Request)
- fmt
- validate
- plan (dev only)
- tflint
- tfsec

No infrastructure is modified.

---

### terraform-apply (Merge to main)

1. Automatically applies changes to **dev**
2. Requires manual approval to apply **prod**

Authentication uses:
- GitHub OIDC → AWS IAM Role
- No long-lived AWS credentials

---

## Quick Start (Local)

### 1) Bootstrap Remote State (run once)

From `aws/`:

```bash
make bootstrap-state \
  STATE_BUCKET=mb-terraform-state-2026 \
  AWS_REGION=eu-central-1 \
  LOCK_TABLE=terraform-locks