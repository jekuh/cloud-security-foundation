# GCP From An AWS Mindset

This note is for learning the GCP part of the repository if you already think in AWS terms.

## Start With The Mental Model

The biggest difference is that GCP pushes more through project-level services and service accounts, while AWS often feels more account-and-IAM-role centered.

Useful translation:

| AWS | GCP |
|-----|-----|
| Account | Project |
| IAM role for workload | Service account |
| AssumeRole / OIDC to role | Workload Identity Federation to service account |
| VPC | VPC network |
| Subnet | Subnetwork |
| NAT Gateway | Cloud NAT |
| Internet-facing EC2 | Compute Engine VM with external IP |
| S3 | GCS |
| CloudWatch Logs destination | Cloud Logging sink |

## What The GCP Environment Creates

When you apply `gcp/envs/dev`, the code creates:

- required project APIs
- three service accounts
- one VPC and two subnets
- one router and NAT
- one application bucket and one logs bucket
- one logging sink
- two VMs
- one SSH firewall rule

That is enough to learn the main GCP building blocks without starting from a very large platform design.

## How To Read The GCP Code

Start in [gcp/envs/dev/main.tf](../gcp/envs/dev/main.tf). That file is the composition root.

Read it in this order:

1. `project_services`
2. `identity`
3. `storage`
4. `monitoring`
5. `network`
6. `compute`
7. `servers`

That order matches the dependency chain reasonably well.

## How To Think About Each Module

### `project_services`

In AWS, many services are simply available. In GCP, an API can exist conceptually but still be disabled for your project. This module enables the APIs the rest of the stack needs.

### `identity`

This creates a service account for the application layer. Think of it as closer to an IAM role attached to a workload than to an IAM user.

### `network`

This creates:

- a VPC network
- a public subnetwork
- a private subnetwork
- a Cloud Router
- a Cloud NAT

If you know AWS, the closest analogy is a VPC with public and private subnets plus outbound NAT for private workloads.

### `storage`

This creates the application GCS bucket. The bucket has:

- versioning enabled
- public access prevention enabled
- optional CMEK if you pass `kms_key_name`

The main difference from S3 thinking is that bucket names are globally unique across all GCP customers.

### `monitoring`

This creates:

- a logs bucket
- a logging sink that exports instance logs to that bucket

Think of the sink as the routing rule and the bucket as the storage destination.

### `compute`

This creates one Compute Engine VM and a service account for it. The VM has:

- a machine type
- a boot disk
- a network interface
- an external IP because of `access_config`
- OS Login enabled through metadata

### `servers`

This creates a second VM plus an SSH firewall rule. The firewall rule is broad right now so it is easy to test, but it is also the first thing you should tighten.

## Common First-Time GCP Lessons

### APIs must be enabled

A Terraform plan can be valid while apply still fails because the project has not enabled a service such as Compute Engine yet.

### Bucket names are global

If a bucket name looks locally unique but is still rejected, that usually means someone anywhere in GCP already has it.

### Service accounts matter early

In AWS it is easy to think first in networks and instances. In GCP, service accounts show up very early because many resources and automation paths depend on them.

### Logging is more routing-oriented

Cloud Logging sinks are worth understanding early. They are a core part of how logs move to storage, BigQuery, or Pub/Sub.

## Suggested Hands-On Learning Path

1. Read [gcp/envs/dev/main.tf](../gcp/envs/dev/main.tf) and identify which module creates each output.
2. Open each module under [gcp/modules](../gcp/modules) and map the Terraform resources to the GCP Console.
3. In the GCP Console, inspect:
   - VPC network
   - subnets
   - Cloud NAT
   - Compute Engine instances
   - service accounts
   - GCS buckets
   - Cloud Logging sink
4. Restrict SSH to your IP and reapply.
5. Remove one VM public IP and see how that changes access assumptions.
6. Add a KMS key and pass `kms_key_name` to the storage module.

## Good Next Questions To Explore

- When should a GCP VM have an external IP versus using IAP or a bastion?
- What is the smallest IAM surface GitHub Actions really needs?
- Which resources should move from Google-managed encryption to customer-managed encryption?
- How should logs be retained and protected for incident response?
