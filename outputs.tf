# ------------------------------------------------------------------------------
# SECURITY GROUP OUTPUTS
# ------------------------------------------------------------------------------

output "security_group_ids" {
  description = "Map of security group names to their IDs"
  value = {
    for name, sg in aws_security_group.this : name => sg.id
  }
}

output "security_group_arns" {
  description = "Map of security group names to their ARNs"
  value = {
    for name, sg in aws_security_group.this : name => sg.arn
  }
}

output "security_group_names" {
  description = "Map of security group keys to their actual names"
  value = {
    for name, sg in aws_security_group.this : name => sg.name
  }
}

# ------------------------------------------------------------------------------
# CONVENIENCE OUTPUTS
# ------------------------------------------------------------------------------

output "security_groups" {
  description = "Map of all security groups with their attributes"
  value = {
    for name, sg in aws_security_group.this : name => {
      id   = sg.id
      arn  = sg.arn
      name = sg.name
      tier = var.security_groups[name].tier
    }
  }
}
