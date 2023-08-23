locals {
  org_member_list = yamldecode(file(var.org_member_account_list_file))
  securitylake_admin = toset([
    for member in local.org_member_list : trimspace(member.name)
    if lookup(member, "securitylake_delegate", false)
  ])
}