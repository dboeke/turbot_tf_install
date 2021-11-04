resource "aws_cloudformation_stack" "workspace" {
  for_each      = var.workspaces
  depends_on = [
    aws_cloudformation_stack.te,
    aws_cloudformation_stack.tef,
    aws_cloudformation_stack.ted
  ]
  name          = "${var.prefix}-workspace-${each.key}"
  template_body = file("${path.module}/workspace.cf.yml")
  parameters   = {
    Name                        = each.key
    Version                     = each.value
    Hive                        = var.db_name
    UseRoute53                  = var.use_route53 == "Enabled" ? "true" : "false"
    FoundationStackOutputPrefix = var.prefix
    AlternateURL                = ""
    InstallationDomainSsmValue  = "/${var.prefix}/enterprise/installation_domain"
  }
  timeouts {
    create = "15m"
    delete = "15m"
    update = "15m"
  }
}