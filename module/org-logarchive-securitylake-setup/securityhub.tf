resource "aws_securityhub_organization_configuration" "sh" {
  auto_enable           = true
  auto_enable_standards = "DEFAULT"
}

# Enable CIS foundations benchmark
resource "aws_securityhub_standards_subscription" "cis_aws_foundations_benchmark" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

# #AWS Foundational Security Best Practices
resource "aws_securityhub_standards_subscription" "pci_321" {
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
}
