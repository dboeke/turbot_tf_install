resource "aws_cloudformation_stack" "ted" {
  depends_on = [
    aws_cloudformation_stack.tef
  ]
  name         = "${var.prefix}-TED"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  template_url = "https://s3.${var.region}.amazonaws.com/turbot-software-production-${var.region}/ted/${var.versions.ted}/index.yml"
  parameters   = {
    ## Installation
    ResourceNamePrefix         = var.prefix
    ParameterDeploymentTrigger = var.ted_deploy_trigger

    ## DB Configuration
    HiveName            = var.db_name
    PrimaryRegion       = var.region
    InstanceClass       = var.db_instance_type
    FailoverInstance    = var.create_failover
    ReadReplicaInstance = var.create_read_replica
    Engine              = var.db_engine
    EngineFamily        = var.db_family
    EngineVersion       = var.db_engine_version
    StorageType         = var.db_storage_type
    AllocatedStorage    = var.curr_allocated_mb
    MaxAllocatedStorage = var.max_allocaated_mb
    AllocatedIops       = var.allocated_iops
    EncryptDatabase     = var.encryption_key
    DeletionProtection  = var.enable_del_protect
    PerformanceInsights = var.enable_perf_insight
    StatementTimeout    = var.db_timeout_ms
    MaxConnections      = var.max_db_connections

    ## DB Backup Config
    BackupRetentionPeriod      = var.BackupRetentionPeriod
    DailyAutomatedBackup       = var.DailyAutomatedBackup
    WeeklyAutomatedBackup      = var.WeeklyAutomatedBackup 
    MonthlyAutomatedBackup     = var.MonthlyAutomatedBackup 
    AutomatedBackupPlanRoleArn = var.AutomatedBackupPlanRoleArn
    DeleteAutomatedBackups     = var.DeleteAutomatedBackups
    BackupVaultNameFormat      = var.BackupVaultNameFormat
    CopyTagsToSnapshot         = var.CopyTagsToSnapshot

    ## Cache Configuration
    UseElastiCache      = var.use_elasticache
    CacheNodeType       = var.redis_node_type  

    ## SSM Params - Do not change
    FoundationAlphaRegion         = "/${var.prefix}/enterprise/alpha_region"
    DatabaseSubnetGroupValue      = "/${var.prefix}/enterprise/db_subnet_group"
    VpcSecurityGroupsValue        = "/${var.prefix}/enterprise/db_security_group"
    AuditTrailRetentionDaysValue  = "/${var.prefix}/enterprise/audit_trail_retention_days"
    KeyAliasSsmValue              = "/${var.prefix}/enterprise/foundation_key_alias"
    FoundationLogBucketNameFormat = "/${var.prefix}/enterprise/log_bucket_name_format"
    FoundationDynamicBucketName   = "/${var.prefix}/enterprise/dynamic_bucket_name"
  }

  timeouts {
    create = "60m"
    delete = "60m"
    update = "60m"
  }

}