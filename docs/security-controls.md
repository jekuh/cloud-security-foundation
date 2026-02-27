# Security controls (baseline)

- Remote state encrypted + access controlled
- State locking enabled where supported
- S3/GCS/Blob: block public access, encryption, versioning (where applicable)
- Compute: IMDSv2 (AWS), disk encryption, no reliance on default networks
- CI: terraform fmt/validate + tflint + tfsec
