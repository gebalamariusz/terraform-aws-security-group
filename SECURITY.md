# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability in this project, please report it responsibly.

### How to Report

1. **Do not** open a public GitHub issue for security vulnerabilities
2. Email the maintainer directly at: **security@haitmg.pl**
3. Include as much information as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Acknowledgment**: Within 48 hours of your report
- **Assessment**: We will investigate and assess the severity within 7 days
- **Resolution**: Critical vulnerabilities will be addressed as soon as possible
- **Disclosure**: We will coordinate with you on public disclosure timing

### Scope

This security policy applies to:
- All Terraform code in this repository
- CI/CD configurations
- Documentation that could lead to misconfiguration

### Out of Scope

- Vulnerabilities in Terraform itself (report to HashiCorp)
- Vulnerabilities in AWS services (report to AWS)
- Issues in third-party dependencies (report to respective maintainers)

## Security Best Practices

When using this module, we recommend:

1. **Pin versions** - Always use specific version tags, not `main` branch
2. **Review changes** - Check release notes before upgrading
3. **Least privilege** - Use minimal IAM permissions required
4. **Enable logging** - Use VPC Flow Logs and CloudTrail
5. **Encrypt data** - Enable encryption for all supported resources

## Recognition

We appreciate security researchers who help keep this project safe. Contributors who report valid vulnerabilities will be acknowledged in our release notes (unless they prefer to remain anonymous).

Thank you for helping keep this module secure!
