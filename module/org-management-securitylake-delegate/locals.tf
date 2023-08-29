locals {
  org_member_list = compact(yamldecode(file(var.org_member_account_list_file)))
  org_ou_map = length(local.org_member_list) > 0 ? toset([for member in local.org_member_list : member.unit]) : toset([])
  securitylake_admin = length(local.org_member_list) > 0 ? toset([
    for member in local.org_member_list : trimspace(member.name)
    if lookup(member, "securitylake_delegate", false)
  ]) : toset([])
}