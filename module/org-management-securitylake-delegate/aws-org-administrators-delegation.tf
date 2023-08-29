resource "aws_cloudtrail" "cloudtrail-management" {
  for_each = length(local.securitylake_admin) == 1 ? local.securitylake_admin : toset([])

  name           = var.cloudtrail_name
  s3_bucket_name = aws_s3_bucket.cloudtrail-management[each.key].id
  s3_key_prefix  = ""

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }
  enable_logging                = true
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  is_organization_trail         = false

  depends_on = [aws_s3_bucket.cloudtrail-management, aws_s3_bucket_policy.cloudtrail-management]
}

resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "cloudtrail-management" {
  for_each      = length(local.securitylake_admin) == 1 ? local.securitylake_admin : toset([])
  bucket        = "aws-cloudtrail-logs-${aws_organizations_account.member[each.key].id}-${random_string.random_suffix.result}"
  force_destroy = true
  depends_on    = [aws_organizations_account.member]
}

resource "aws_s3_bucket_policy" "cloudtrail-management" {
  for_each = length(local.securitylake_admin) == 1 ? local.securitylake_admin : toset([])
  bucket   = aws_s3_bucket.cloudtrail-management[each.key].id
  policy = templatefile("resources/aws_s3_cloudtrail_permission.json.tftpl", {
    account_id  = data.aws_caller_identity.current.account_id
    bucket_name = "aws-cloudtrail-logs-${aws_organizations_account.member[each.key].id}-${random_string.random_suffix.result}"
    region      = data.aws_region.current.name
    trail_name  = var.cloudtrail_name
  })
}

resource "aws_organizations_delegated_administrator" "cloudtrail" {
  for_each = toset([
    for member in local.org_member_list : trimspace(member.name)
    if lookup(member, "securitylake_delegate", false)
  ])
  account_id        = aws_organizations_account.member[each.key].id
  service_principal = "cloudtrail.amazonaws.com"
  depends_on        = [aws_organizations_account.member]
}

resource "aws_organizations_delegated_administrator" "config" {
  for_each = toset([
    for member in local.org_member_list : trimspace(member.name)
    if lookup(member, "securitylake_delegate", false)
  ])
  account_id        = aws_organizations_account.member[each.key].id
  service_principal = "config.amazonaws.com"
  depends_on        = [aws_organizations_account.member]
}

resource "aws_securityhub_organization_admin_account" "securityhub" {
  for_each = toset([
    for member in local.org_member_list : trimspace(member.name)
    if lookup(member, "securitylake_delegate", false)
  ])
  admin_account_id = aws_organizations_account.member[each.key].id
  depends_on       = [aws_organizations_account.member]
}