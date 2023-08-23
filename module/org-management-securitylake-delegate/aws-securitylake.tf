resource "null_resource" "securitylake_delegation" {
  for_each = toset([
    for member in local.org_member_list : trimspace(member.name)
    if lookup(member, "securitylake_delegate", false)
  ])

  provisioner "local-exec" {
    command = "python3 scripts/aws-securitylake-delegation.py --delegation_id '${aws_organizations_account.member[each.key].id}'"
  }
}