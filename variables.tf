# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "VPC ID must start with 'vpc-'."
  }
}

variable "security_groups" {
  description = <<-EOT
    Map of security groups to create. The key is the security group name.

    Each security group object supports:
    - description (required) - Description of the security group
    - tier        (optional) - Tier name for tagging (e.g., "public", "application")
    - ingress     (optional) - Map of ingress rules (key = rule name, stable identifier)
    - egress      (optional) - Map of egress rules (key = rule name, stable identifier)

    Each rule supports:
    - port        (required) - Port number (use -1 for all ports)
    - protocol    (optional) - Protocol (tcp, udp, icmp, -1 for all). Default: tcp
    - cidr_blocks (optional) - List of CIDR blocks
    - source_sg   (optional) - Name of source security group (from this module)
    - description (optional) - Rule description

    IMPORTANT: Use descriptive keys for rules (e.g., "https", "http-redirect").
    Keys are stable identifiers - changing them will destroy/recreate rules.
  EOT
  type = map(object({
    description = string
    tier        = optional(string, "")
    ingress = optional(map(object({
      port        = number
      protocol    = optional(string, "tcp")
      cidr_blocks = optional(list(string), [])
      source_sg   = optional(string, "")
      description = optional(string, "")
    })), {})
    egress = optional(map(object({
      port        = number
      protocol    = optional(string, "tcp")
      cidr_blocks = optional(list(string), [])
      source_sg   = optional(string, "")
      description = optional(string, "")
    })), {})
  }))

  validation {
    condition     = length(var.security_groups) > 0
    error_message = "At least one security group must be defined."
  }
}

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------------------------------

variable "name" {
  description = "Name prefix for all resources"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name (used in naming/tagging if provided)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
