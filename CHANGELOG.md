# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-28

### Added

- Initial release of AWS Security Group Terraform module
- Multiple security groups creation from single configuration
- Flexible ingress and egress rules with stable identifiers
- Support for CIDR-based rules (one resource per CIDR for clean updates)
- Support for source security group references within the module
- Tier-based tagging for security group organization
- Consistent naming with name prefix and environment
- Consistent tagging with `ManagedBy`, `Module`, and optional `Tier` tags
- Comprehensive outputs including IDs, ARNs, and names
- CI pipeline with terraform fmt, validate, tflint, and tfsec
- MIT License

[1.0.0]: https://github.com/gebalamariusz/terraform-aws-security-group/releases/tag/v1.0.0
