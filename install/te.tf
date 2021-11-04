resource "aws_cloudformation_stack" "te" {
  depends_on = [
    aws_cloudformation_stack.tef,
    aws_cloudformation_stack.ted
  ]
  for_each     = var.versions.te
  name         = "${var.prefix}-TE-${replace(each.key,".","-")}"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  template_url = "https://s3.${var.region}.amazonaws.com/turbot-software-production-${var.region}/te/${each.key}/index.yml"
  parameters   = {

    ## Installation
    ResourceNamePrefix          = var.prefix
    ParameterDeploymentTrigger  = each.value

    ## Network overrides - Leave blank unless directed otherwise
    TurbotLoadBalancerSubnetIds = ""
    TurbotApplicationSubnetIds  = ""
    TurbotCertificateArn        = ""

    ## Advanced - Deployment
    ReleasePhase       = "production"
    RoleCreationScheme = "All"

    ## SSM Params - Do not change without speaking to support
    ElastiCacheSsmValue = "/${var.prefix}/enterprise/use_elasticache"
    HttpProxySsmValue = "/${var.prefix}/enterprise/http_proxy"
    HttpsProxySsmValue = "/${var.prefix}/enterprise/https_proxy"
    NoProxySsmValue = "/${var.prefix}/enterprise/no_proxy"
    TurbotVpcSsmValue = "/${var.prefix}/enterprise/vpc"
    RegionsSsmValue = "/${var.prefix}/enterprise/regions"
    KeyAliasSsmValue = "/${var.prefix}/enterprise/transient_key_alias"
    LogBucketSsmValue = "/${var.prefix}/enterprise/log_bucket"
    InstallationDomainSsmValue = "/${var.prefix}/enterprise/installation_domain"
    DatabaseSecurityGroupSsmValue = "/${var.prefix}/enterprise/db_security_group"
    OutboundInternetSecurityGroupSsmValue = "/${var.prefix}/enterprise/outbound_internet_security_group"
    LdapSecurityGroupSsmValue = "/${var.prefix}/default/enterprise/ldap_security_group"
    LoadBalancerSecurityGroupSsmValue = "/${var.prefix}/enterprise/load_balancer_security_group"
    CertificateArnSsmValue = "/${var.prefix}/enterprise/certificate_arn"
    ManagedRoute53SsmValue = "/${var.prefix}/enterprise/managed_route53"
    LoadbalancerSubnetIdsSsmValue = "/${var.prefix}/enterprise/loadbalancer_subnets"
    TurbotSubnetIdsSsmValue = "/${var.prefix}/enterprise/turbot_subnets"
    LogRetentionDaysSsmValue = "/${var.prefix}/enterprise/log_retention_days"
    LoadBalancerSchemeSsmValue = "/${var.prefix}/enterprise/load_balancer_scheme"
    InboundTrafficCidrSsmValue = "/${var.prefix}/enterprise/load_balancer_inbound_cidr"
    ApiDesiredScaleSsmValue = "/${var.prefix}/enterprise/api_desired_scale"
    ApiMinScalingSsmValue = "/${var.prefix}/enterprise/api_min_scale"
    ApiMaxScalingSsmValue = "/${var.prefix}/enterprise/api_max_scale"
    UseCustomOutboundInternetSecurityGroup = "/${var.prefix}/enterprise/use_custom_outbound_internet_security_group"
    AllowSelfSignedCertificateSsmValue = "/${var.prefix}/enterprise/allow_self_signed_certificate"
    FlagsSsmValue = "/${var.prefix}/enterprise/flags"
    AlphaRegionSsmValue = "/${var.prefix}/enterprise/alpha_region"
    ModLambdaMaxMemorySsmValue = "/${var.prefix}/enterprise/mod_lambda_max_memory"
    ModLambdaMaxTimeoutSsmValue = "/${var.prefix}/enterprise/mod_lambda_max_timeout"
    WorkerLambdaReservedConcurrencySsmValue = "/${var.prefix}/enterprise/worker_lambda_reserved_concurrency"
    WorkerLambdaMessageBatchSsmValue = "/${var.prefix}/enterprise/worker_lambda_message_batch"
    WorkerLambdaMemorySizeSsmValue = "/${var.prefix}/enterprise/worker_lambda_memory_size"
    WorkerLambdaTimeoutSsmValue = "/${var.prefix}/enterprise/worker_lambda_timeout"
    WorkerLambdaMaxDBConnectionsSsmValue = "/${var.prefix}/enterprise/worker_lambda_max_db_connections"
    OSGuardrailsSsmValue = "/${var.prefix}/enterprise/os_guardrails"

  }

  timeouts {
    create = "30m"
    delete = "60m"
    update = "30m"
  }
  
}