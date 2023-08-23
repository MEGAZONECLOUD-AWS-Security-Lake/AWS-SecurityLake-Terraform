resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types

  # Specify "ALL" (default) or "CONSOLIDATED_BILLING".
  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "ou" {
  for_each  = toset([for member in local.org_member_list : member.unit])
  name      = each.key
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_account" "member" {

  for_each = {
    for member in local.org_member_list : trimspace(member.name) => { email = trimspace(member.email), unit = trimspace(member.unit) }
  }

  # A friendly name for the member account.
  # Minimum length of 1. Maximum length of 50.
  # https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateAccount.html#organizations-CreateAccount-request-AccountName
  name = each.key

  # The email address of the owner to assign to the new member account.
  # This email address must not already be associated with another AWS account.
  # You must use a valid email address to complete account creation.
  # You can't access the root user of the account or remove an account that was created with an invalid email address.
  # Minimum length of 6. Maximum length of 64.
  # https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateAccount.html#organizations-CreateAccount-request-Email
  email = each.value.email

  # If set to ALLOW, the new account enables IAM users to access account billing information if they have the required permissions.
  # If set to DENY, only the root user of the new account can access account billing information.
  # Valid value is ALLOW or DENY.
  # https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateAccount.html#organizations-CreateAccount-request-IamUserAccessToBilling
  iam_user_access_to_billing = "DENY"

  # The name of an IAM role that AWS Organizations automatically preconfigures in the new member account.
  # This role trusts the master account, allowing users in the master account to assume the role,
  # as permitted by the master account administrator. The role has administrator permissions in the new member account.
  # https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateAccount.html#organizations-CreateAccount-request-RoleName
  role_name = "OrganizationAccountAccessRole"

  # If true, a deletion event will close the account. Otherwise, it will only remove from the organization. This is not supported for GovCloud accounts.
  close_on_deletion = true

  parent_id = contains(keys(aws_organizations_organizational_unit.ou), each.value.unit) ? aws_organizations_organizational_unit.ou[each.value.unit].id : aws_organizations_organization.org.roots[0].id

  lifecycle {
    # Ignore changes to tags, e.g. because a management agent
    # updates these based on some ruleset managed elsewhere.
    ignore_changes = [role_name]
  }
}