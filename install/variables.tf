

variable "versions" {
  description = "Map of TEF, TED and TE versions to install"
}

variable "workspaces" {
  description = "Map of workspaces to install."
}

variable "prefix" {
  description = "Typically `turbot`, don't change unless required."
}

variable "domain" {
  description = "Base domain that will be used by the Turbot console."
}

variable "license" {
  description = "Turbot license key, obtain from Turbot Support."
}

variable "region" {
  description = "Main installation region (alpha region)"
}

variable "tef_deploy_trigger" {
  description = "Set to Blue or Green to trigger deployment when nothing has changed."
}

variable "ted_deploy_trigger" {
  description = "Set to Blue or Green to trigger deployment when nothing has changed."
}

# Networking

variable "vpc_id" {
  description = "ID of Installation VPC"
}

variable "web_subnets" {
  description = "Subnets to install the load balancer, minimum 2, comma delimited."
}

variable "app_subnets" {
  description = "Subnets to install the ECS cluster, minimum 2, comma delimited."
}

variable "db_subnets" {
  description = "Subnets to install the database cluster, minimum 2, comma delimited."
}

variable "vpc_cidr" {
  description = "CIDR range that encompasses all CIDR addresses used in the VPC. Used for security group config."
}

variable "acm_certificate" {
  description = "ARN of ACM certificate, should match *.domain"
}

variable "use_route53" {
  description = "Enable Turbot to manage a route53 subdomain in this account matching the installation domain."
}

variable "use_api_gateway" {
  description = "Enablke Turbot to create an API gateway, required unless Turbot console is public accessible."
}

## Network - Load Balancer
variable "alb_type" {
  description = "Type of load balancer.  `internet-facing` or `internal`"
}

variable "inbound_api_cidr" {
  description = "CIDR Range to allow access to Load Balancer"
}

## Network - Security Groups
variable "oia_sg" {
  description = "Security group ID for outbound internet access security group. Leave blank for stack to create."
}

variable "alb_sg" {
  description = "Security group ID for load balancer security group. Leave blank for stack to create."
}

variable "api_sg" {
  description = "Security group ID for ecs security group. Leave blank for stack to create."
}

variable "ldap_cidr" {
  description = "Outbound CIDR to allow access for LDAP connectivity."
}

#logging

variable "turbot_log_days" {
  description = "Retention days for installation and configuration logs"
}

variable "process_log_days" {
  description = "Retention days for control and guardrail process logs"
}

variable "audit_trail_days" {
  description = "Retention days for API audit logs"
}
 
## ECS EC2 Config
variable "ecs_instance_type" {
  description = "AWS EC2 Instance Type for ECS"
}

variable "ecs_ami_param" {
  description = "AWS SSM Parameter Path to AMI ID for ECS"
}

variable "ecs_min_instance" {
  description = "Minimum number of ECS instances to run"
}

variable "ecs_max_instance" {
  description = "Maximum number of ECS instances to run"
}

## Advanced - Scaling
variable "lambda_concurrency" {
  description = "Number of concurrent lambda workers allowed."
}

variable "lambda_batch" {
  description = "Number of events each worker pulls from the queue."
}

variable "lambda_db_conn" {
  description = "Number of connections each lambda can make to the DB"
}

## DB Configuration

variable "db_name" {
  description = "Name of database. Keep short lowercase, and no special char."
  default     = "edison"
}

variable "db_instance_type" {
  description = "Valid RDS instance type for postgres in this aws partition/region."
  default     = "db.m6g.large"
}

variable "create_failover" {
  description = "Create a fail over instance for high availability deployments."
  default     = "false"
}

variable "create_read_replica" {
  description = "Not generally necessary, don't enable without discussing with turbot support."
  default     = "false"
}

variable "db_engine" {
  description = "Should be postgres"
  default     = "postgres"
}

variable "db_family" {
  description = "Database engine parameter group family. Should reflect the current database major version"
  default     = "postgres13"
}

variable "db_engine_version" {
  description = "Current version of postgres to use."
  default     = "13.4"
}

variable "db_storage_type" {
  description = "io1 for provisioned iops, gp2 for small envioronments"
  default     = "io1"
}

variable "curr_allocated_mb" {
  description = "Allocated Storage in GB. This value is the initial storage that will be allocated to this Hive database"
  default     = "200"
}

variable "max_allocaated_mb" {
  description = "Maximum Allocated Storage limit in GB"
  default     = "1000"
}

variable "allocated_iops" {
  description = "Provisioned IOPs (only used if Storage Type is io1)"
  default     = "3000"
}

variable "encryption_key" {
  description = "Encryption method to use. If `aws/rds` then use the predefined AWS KMS key for RDS. If `Hive CMK` then create a customer managed key specific to the hive."
  default     = "Hive CMK"
}

variable "enable_del_protect" {
  description = ""
  default     = "false"
}

variable "enable_perf_insight" {
  description = "Enable Performance Insights for the database"
  default     = "true"
}

variable "db_timeout_ms" {
  description = "Maximum Allowed Duration of DB Statements in milliseconds"
  default     = "300000"
}

variable "max_db_connections" {
  description = "Maximum number of concurrent connections"
  default     = "600"
}

## Cache Configuration

variable "use_elasticache" {
  description = "Use ElastiCache?  true/false"
  default     = "true"
}

variable "redis_node_type" {
  description = "Type of cache node. WARNING: If changing the Elasticache node size, the `Access Control Option` parameter must be set to `User Group Access Control List` and `User Group Access Control List` set to `<prefix>-<hive>`"
  default     = "cache.r6g.large"
}

## Database Backup

variable "BackupRetentionPeriod" {
  description = "RDS automated backups will be retained for this many days."
  default = 7
}

variable "DailyAutomatedBackup" {
  description = "Daily backups, using backup service, will be retained for this many days. Preferred value is 10. Keep the value 0 in case daily backup is not needed."
  default = 0
}

variable WeeklyAutomatedBackup {
  description = "Weekly backups, using backup service, will be retained for this many days. Preferred value is 56. Keep the value 0 in case weekly backup is not needed."
  default = 0
}

variable MonthlyAutomatedBackup {
  description = "Monthly backups, using backup service, will be retained for this many days. Preferred value is 180. Keep the value 0 in case monthly backup is not needed."
  default = 0
}

variable AutomatedBackupPlanRoleArn {
  description = "Role to be used for creating Automated Backups. Leave empty for Turbot to create this role. Specify the full ARN. If this role is specified, Turbot will not create the role and will use the given role."
  default = ""
}

variable DeleteAutomatedBackups {
  description = "Create final snapshot on deletion. If true, automated backups will be automatically deleted when the primary instance is deleted."
  default = "false"
}

variable BackupVaultNameFormat {
  description = "Determines the name of the Backup Vault. Dynamic appends a semi-random string on the backup vault name."
  default = "constant"
  # AllowedValues: ["constant", "dynamic"]
}

variable CopyTagsToSnapshot {
  description = "If true, tags will be automatically copied from the primary instance to its snapshots."
  default = "true"
}