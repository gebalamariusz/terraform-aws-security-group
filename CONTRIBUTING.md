# Contributing to AWS Security Group Terraform Module

Thank you for your interest in contributing! This document provides guidelines and information about contributing to this project.

## Code of Conduct

Please be respectful and considerate in all interactions.

## How to Contribute

### Reporting Bugs

1. Check existing issues to avoid duplicates
2. Use the bug report template
3. Include Terraform and provider versions
4. Provide minimal reproduction steps

### Suggesting Features

1. Check existing issues and roadmap
2. Use the feature request template
3. Explain the use case clearly

### Submitting Changes

1. Fork the repository
2. Create a feature branch from `main`
3. Make your changes
4. Ensure all CI checks pass
5. Submit a pull request

## Development Guidelines

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding or updating tests
- `ci`: CI/CD changes
- `deps`: Dependency updates

Examples:
```
feat(sg): add support for IPv6 CIDR blocks
fix(rules): correct port range handling
docs(readme): update usage examples
```

### Terraform Conventions

#### Naming

- Use `snake_case` for resource names
- Prefix resources with module name: `aws_security_group.this`
- Use descriptive variable names

#### Structure

```
terraform-aws-security-group/
├── main.tf          # Main resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── versions.tf      # Provider requirements
├── README.md        # Documentation
├── CHANGELOG.md     # Version history
└── LICENSE          # MIT License
```

#### Variables

- Always include `description`
- Use `type` constraints
- Provide sensible `default` values where appropriate
- Add `validation` blocks for complex inputs

#### Outputs

- Output all useful resource attributes
- Use consistent naming: `<resource>_id`, `<resource>_arn`
- Include `description` for all outputs

### Testing

Before submitting:

```bash
# Format
terraform fmt -recursive

# Validate
terraform init -backend=false
terraform validate

# Lint
tflint --init
tflint

# Security
tfsec .
```

### Documentation

- Update README.md when changing inputs/outputs
- Add examples for new features
- Keep examples simple and focused

## Release Process

Releases are created by maintainers using semantic versioning:

- `v1.0.0` - Major (breaking changes)
- `v1.1.0` - Minor (new features)
- `v1.1.1` - Patch (bug fixes)

## Questions?

Open a discussion or issue if you have questions.

Thank you for contributing!
