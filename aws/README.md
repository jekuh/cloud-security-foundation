# AWS Secure Foundation (MVP)

## Completed today
- Remote state bootstrap: **S3 backend + DynamoDB locking**
- Terraform structure: `environments/dev`, `environments/prod`, reusable `modules/`
- Networking: dedicated **VPC + public subnet + IGW + routes** (no default VPC dependency)
- Deployed in `dev`:
  - IAM role
  - S3 app bucket (public access blocked, versioning + encryption enabled)
  - CloudWatch log group
  - EC2 instance (IMDSv2 required, root volume encrypted)
- Local workflow: Makefile targets
- Security checks: `tflint`, `tfsec`

## Quick start (local)

### 1) Bootstrap remote state (run once)
From `aws/`:
```bash
make bootstrap-state STATE_BUCKET=mb-terraform-state-2026 AWS_REGION=eu-central-1 LOCK_TABLE=terraform-locks
```

Update `environments/dev/backend.hcl` and `environments/prod/backend.hcl`:
- replace `REPLACE_WITH_YOUR_BUCKET` with your bucket name

### 2) Deploy dev
```bash
make init
make plan
make apply
make output
```

### 3) Cleanup / cost
```bash
make destroy
```

## CI/CD (next)
1) Create OIDC role:
```bash
make bootstrap-oidc GITHUB_ORG=<org|user> GITHUB_REPO=<repo> STATE_BUCKET=<bucket>
```
2) Add GitHub secret: `AWS_ROLE_TO_ASSUME`
3) Create GitHub Environments: `dev` and `prod` with required reviewers
