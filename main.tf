# ------------------------------------------------------------------------------
# LOCAL VALUES
# ------------------------------------------------------------------------------

locals {
  # Build resource name prefix
  name_prefix = var.environment != "" && var.name != "" ? "${var.name}-${var.environment}" : var.name != "" ? var.name : var.environment

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      ManagedBy = "terraform"
      Module    = "terraform-aws-security-group"
    }
  )

  # Flatten ingress rules - ONE RULE PER CIDR for better update handling
  # CIDR-based rules (one resource per CIDR block)
  ingress_cidr_rules = merge(flatten([
    for sg_name, sg in var.security_groups : [
      for rule_name, rule in sg.ingress : [
        for cidr in rule.cidr_blocks : {
          "${sg_name}-ingress-${rule_name}-${replace(replace(cidr, "/", "-"), ".", "_")}" = {
            sg_name     = sg_name
            type        = "ingress"
            port        = rule.port
            protocol    = rule.protocol
            cidr_block  = cidr
            source_sg   = ""
            description = rule.description
          }
        }
      ] if length(rule.cidr_blocks) > 0
    ]
  ])...)

  # Source SG-based ingress rules (one resource per rule)
  ingress_sg_rules = merge([
    for sg_name, sg in var.security_groups : {
      for rule_name, rule in sg.ingress :
      "${sg_name}-ingress-${rule_name}-sg" => {
        sg_name     = sg_name
        type        = "ingress"
        port        = rule.port
        protocol    = rule.protocol
        cidr_block  = ""
        source_sg   = rule.source_sg
        description = rule.description
      } if rule.source_sg != ""
    }
  ]...)

  # Flatten egress rules - ONE RULE PER CIDR for better update handling
  # CIDR-based rules (one resource per CIDR block)
  egress_cidr_rules = merge(flatten([
    for sg_name, sg in var.security_groups : [
      for rule_name, rule in sg.egress : [
        for cidr in rule.cidr_blocks : {
          "${sg_name}-egress-${rule_name}-${replace(replace(cidr, "/", "-"), ".", "_")}" = {
            sg_name     = sg_name
            type        = "egress"
            port        = rule.port
            protocol    = rule.protocol
            cidr_block  = cidr
            source_sg   = ""
            description = rule.description
          }
        }
      ] if length(rule.cidr_blocks) > 0
    ]
  ])...)

  # Source SG-based egress rules (one resource per rule)
  egress_sg_rules = merge([
    for sg_name, sg in var.security_groups : {
      for rule_name, rule in sg.egress :
      "${sg_name}-egress-${rule_name}-sg" => {
        sg_name     = sg_name
        type        = "egress"
        port        = rule.port
        protocol    = rule.protocol
        cidr_block  = ""
        source_sg   = rule.source_sg
        description = rule.description
      } if rule.source_sg != ""
    }
  ]...)

  # Combine all rules
  all_rules = merge(
    local.ingress_cidr_rules,
    local.ingress_sg_rules,
    local.egress_cidr_rules,
    local.egress_sg_rules
  )
}

# ------------------------------------------------------------------------------
# SECURITY GROUPS
# ------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = local.name_prefix != "" ? "${local.name_prefix}-${each.key}" : each.key
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.name_prefix != "" ? "${local.name_prefix}-${each.key}" : each.key
    },
    each.value.tier != "" ? { Tier = each.value.tier } : {}
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# SECURITY GROUP RULES
# ------------------------------------------------------------------------------

resource "aws_security_group_rule" "this" {
  for_each = local.all_rules

  security_group_id = aws_security_group.this[each.value.sg_name].id
  type              = each.value.type

  from_port = each.value.port == -1 ? 0 : each.value.port
  to_port   = each.value.port == -1 ? 65535 : each.value.port
  protocol  = each.value.protocol

  # Either cidr_blocks (single CIDR as list) or source_security_group_id
  cidr_blocks              = each.value.cidr_block != "" ? [each.value.cidr_block] : null
  source_security_group_id = each.value.source_sg != "" ? aws_security_group.this[each.value.source_sg].id : null

  description = each.value.description != "" ? each.value.description : null
}
