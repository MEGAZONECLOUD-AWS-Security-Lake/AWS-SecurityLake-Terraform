resource "null_resource" "securitylake_delegation" {
  for_each = local.securitylake_admin

  provisioner "local-exec" {
    command = "python3 scripts/aws-securitylake-delegation.py --delegation_id '${aws_organizations_account.member[each.key].id}'"
  }
}