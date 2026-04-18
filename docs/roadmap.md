# Roadmap

## AWS

- reduce remaining tfsec findings
- tighten GitHub OIDC permissions toward least privilege
- add PR plan comments and workflow path filters

## GCP

- restrict SSH access and remove public IPs where not needed
- add CMEK for more resources, not only optional bucket encryption
- add VPC flow logs and stronger logging retention controls
- reduce GitHub Actions service account permissions
- improve production parity and hardening

## Azure

- bootstrap remote state
- bootstrap Entra ID OIDC for GitHub Actions
- implement the same environment and module pattern used in AWS and GCP
