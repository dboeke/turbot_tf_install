resource "aws_cloudformation_stack" "tef" {
  name         = "${var.prefix}-TEF"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  template_url = "https://s3.${var.region}.amazonaws.com/turbot-software-production-${var.region}/tef/${var.versions.tef}/index.yml"
  parameters   = {
    #installation
    InstallationDomain         = var.domain
    TurbotCertificateArn       = var.acm_certificate
    LicenseKey                 = var.license
    ResourceNamePrefix         = var.prefix
    ParameterDeploymentTrigger = var.tef_deploy_trigger
    RegionCode                 = "alpha"
    
    ## Network
    PredefinedVpcId             = var.vpc_id
    PredefinedPublicSubnetIds   = var.web_subnets
    PredefinedTurbotSubnetIds   = var.app_subnets
    PredefinedDatabaseSubnetIds = var.db_subnets
    VpcAlphaRegion              = var.region
    VpcAlphaCidr                = var.vpc_cidr
    ManagedRoute53              = var.use_route53
    CreateApiGateway            = var.use_api_gateway

    ## Network - Proxy
    HttpProxy  = "null"
    HttpsProxy = "null"
    NoProxy    = "169.254.169.254,169.254.170.2,localhost"

    ## Network - Load Balancer
    LoadBalancerScheme = var.alb_type
    InboundTrafficCidr = var.inbound_api_cidr

    ## Network - Security Groups
    CustomOutboundInternetSecurityGroup = var.oia_sg
    CustomLoadBalancerSecurityGroup     = var.alb_sg
    CustomApiServiceSecurityGroup       = var.api_sg
    LdapServerCidr                      = var.ldap_cidr

    #logging
    LogBucketName             = "constant"
    ProcessLogBucketName      = "constant"
    LogRetentionDays          = var.turbot_log_days
    ProcessLogRetentionInDays = var.process_log_days
    AuditTrailRetentionDays   = var.audit_trail_days

    ## ECS EC2 Config
    InstanceType        = var.ecs_instance_type
    ECSAMI              = var.ecs_ami_param
    ECSMinInstanceCount = var.ecs_min_instance
    ECSMaxInstanceCount = var.ecs_max_instance

    ## Advanced - Cache
    UseElastiCache      = "true"
    ModLambdaMaxMemory  = "2048"
    ModLambdaMaxTimeout = "300"

    ## Advanced - Worker
    WorkerLambdaReservedConcurrency = var.lambda_concurrency
    WorkerLambdaMessageBatch        = var.lambda_batch
    WorkerLambdaMemorySize          = "3008"
    WorkerLambdaTimeout             = "450"
    WorkerLambdaMaxDBConnections    = var.lambda_db_conn

    ## Advanced - Deployment
    ReleasePhase       = "production"
    Flags              = "NONE"
    OSGuardrails       = "off"
    RoleCreationScheme = "All"
    
  }
  timeouts {
    create = "60m"
    delete = "60m"
    update = "60m"
  }
}