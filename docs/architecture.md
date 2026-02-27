# Architecture

Each cloud follows the same pattern:

- `bootstrap/`:
  - remote state storage
  - CI/CD identity (OIDC / federation)
- `envs/dev` and `envs/prod`:
  - isolated state + config
- `modules/`:
  - identity / compute / storage / monitoring

CI/CD:
- PR: fmt + validate + tflint + tfsec + plan
- main: apply with GitHub Environment approvals
