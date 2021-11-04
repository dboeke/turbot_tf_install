versions = {
  tef = "1.35.0"
  ted = "1.22.0"
  te  = {
    "5.37.17" = "Blue",
    "5.37.19" = "Blue"
  }
}

workspaces = {
  console = "5.37.19"
}

#installation
prefix  = "apple"
domain  = "dmi.turbot.mantix.io"
license = ""
region  = "us-east-2"
tef_deploy_trigger = "Blue"
ted_deploy_trigger = "Blue"

#networking
vpc_id          = "vpc-0d577b447f4e3239e"
vpc_cidr        = "10.11.0.0/16"
web_subnets     = "subnet-0b2f866c00dd23ede,subnet-09c8e68320792f101"
app_subnets     = "subnet-0f3d6fa8bd8175f9f,subnet-0ef4f73ffcc79ba04"
db_subnets      = "subnet-0f3d6fa8bd8175f9f,subnet-0ef4f73ffcc79ba04"
acm_certificate = "arn:aws:acm:us-east-2:146794183450:certificate/c7468a56-3663-46a0-98f6-7853cb82a817"
use_route53     = "Enabled"
use_api_gateway = "Enabled"

## Network - Load Balancer
alb_type         = "internet-facing"
inbound_api_cidr = "0.0.0.0/0"

## Network - Security Groups
oia_sg    = "sg-000be724e71738c60"
alb_sg    = "sg-03876c5c2e8bd8c75"
api_sg    = "sg-0a91ee4cbd46ae968"

# If user wants LDAP enabled, irrespective of whether or not they want to use the security group created by turbot,
# they would enter their LDAP Server Cidr in TEF, which will create a sg by default and the sg id will be stored in
# the default parameter, if user then wants to override it, they can create their own sg and store the value in the
# override parameter. But if the user doesn't want LDAP enabled, then they should leave the LDAP Server Cidr blank,
# this will cause the default parameter to store {% NULL %} as the value.
ldap_cidr = ""

#logging
turbot_log_days  = "30"
process_log_days = "395"
audit_trail_days = "365"
 
## ECS EC2 Config
ecs_instance_type = "t3.large"
ecs_ami_param     = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
ecs_min_instance  = "1"
ecs_max_instance  = "4"

## Advanced
lambda_concurrency = "50"
lambda_batch       = "4"
lambda_db_conn     = "4"

## Database 

## DB Configuration
db_name             = "newton"
db_instance_type    = "db.m6g.large"
create_failover     = "false"
create_read_replica = "false"
db_engine           = "postgres"
db_family           = "postgres13"
db_engine_version   = "13.4"
db_storage_type     = "io1"
curr_allocated_mb   = "200"  #important
max_allocaated_mb   = "1000"
allocated_iops      = "3000"
encryption_key      = "aws/rds" # or "Hive CMK"
enable_del_protect  = "false"
enable_perf_insight = "false"
db_timeout_ms       = "300000"
max_db_connections  = "600"

## Cache Configuration
use_elasticache     = "true"
redis_node_type     = "cache.r6g.large"