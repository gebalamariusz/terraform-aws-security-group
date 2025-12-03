# AWS Security Group Terraform Module

[![Terraform Registry](https://img.shields.io/badge/Terraform%20Registry-gebalamariusz%2Fsecurity--group%2Faws-blue?logo=terraform)](https://registry.terraform.io/modules/gebalamariusz/security-group/aws)
[![CI](https://github.com/gebalamariusz/terraform-aws-security-group/actions/workflows/ci.yml/badge.svg)](https://github.com/gebalamariusz/terraform-aws-security-group/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/gebalamariusz/terraform-aws-security-group?display_name=tag&sort=semver)](https://github.com/gebalamariusz/terraform-aws-security-group/releases)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.7-purple.svg)](https://www.terraform.io/)

Terraform module to create Security Groups with ingress and egress rules.

This module is designed to work seamlessly with [terraform-aws-vpc](https://github.com/gebalamariusz/terraform-aws-vpc) and [terraform-aws-subnets](https://github.com/gebalamariusz/terraform-aws-subnets) modules.

## Features

- Creates multiple Security Groups from a single map
- Supports ingress and egress rules
- Supports CIDR blocks and security group references
- Cross-SG references within the same module (e.g., ALB -> ECS)
- Tier-based tagging for organization
- Consistent naming and tagging conventions

## Usage

### Basic usage

```hcl
module "security_groups" {
  source  = "gebalamariusz/security-group/aws"
  version = "~> 1.0"

  name        = "my-app"
  environment = "prod"
  vpc_id      = module.vpc.vpc_id

  security_groups = {
    "alb" = {
      description = "ALB Security Group"
      tier        = "public"
      ingress = {
        "https" = { port = 443, cidr_blocks = ["0.0.0.0/0"], description = "HTTPS from internet" }
      }
      egress = {
        "all" = { port = -1, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], description = "All outbound" }
      }
    }
    "ecs" = {
      description = "ECS Tasks Security Group"
      tier        = "application"
      ingress = {
        "from-alb" = { port = 8080, source_sg = "alb", description = "From ALB" }
      }
      egress = {
        "all" = { port = -1, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], description = "All outbound" }
      }
    }
    "efs" = {
      description = "EFS Security Group"
      tier        = "application"
      ingress = {
        "nfs-from-ecs" = { port = 2049, source_sg = "ecs", description = "NFS from ECS" }
      }
    }
  }
}

# Reference security groups
resource "aws_lb" "this" {
  security_groups = [module.security_groups.security_group_ids["alb"]]
  # ...
}
```

### Integration with VPC definition in tfvars

```hcl
# terraform.tfvars
vpcs = {
  "my-vpc" = {
    cidr_block = "10.0.0.0/16"
    subnets = {
      "10.0.1.0/24" = { az = "eu-west-1a", tier = "public", public = true }
      "10.0.2.0/24" = { az = "eu-west-1a", tier = "application" }
    }
    security_groups = {
      "alb" = {
        description = "ALB Security Group"
        tier        = "public"
        ingress = {
          "https" = { port = 443, cidr_blocks = ["0.0.0.0/0"], description = "HTTPS" }
        }
      }
    }
  }
}

# main.tf
module "security_groups" {
  source   = "gebalamariusz/security-group/aws"
  for_each = var.vpcs

  vpc_id          = module.vpc[each.key].vpc_id
  security_groups = each.value.security_groups

  name        = each.key
  environment = var.environment
  tags        = var.tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | ID of the VPC where security groups will be created | `string` | n/a | yes |
| security_groups | Map of security groups with their rules | `map(object)` | n/a | yes |
| name | Name prefix for all resources | `string` | `""` | no |
| environment | Environment name | `string` | `""` | no |
| tags | Additional tags for all resources | `map(string)` | `{}` | no |

### Security Group Object

| Attribute | Description | Type | Required |
|-----------|-------------|------|:--------:|
| description | Security group description | `string` | yes |
| tier | Tier name for tagging | `string` | no |
| ingress | Map of ingress rules (key = stable rule identifier) | `map(object)` | no |
| egress | Map of egress rules (key = stable rule identifier) | `map(object)` | no |

### Rule Object

| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| port | Port number (-1 for all) | `number` | required |
| protocol | Protocol (tcp, udp, icmp, -1) | `string` | `"tcp"` |
| cidr_blocks | List of CIDR blocks | `list(string)` | `[]` |
| source_sg | Name of source SG from this module | `string` | `""` |
| description | Rule description | `string` | `""` |

## Outputs

| Name | Description |
|------|-------------|
| security_group_ids | Map of security group names to their IDs |
| security_group_arns | Map of security group names to their ARNs |
| security_group_names | Map of security group keys to actual names |
| security_groups | Map of all security groups with full attributes |

## License

MIT
