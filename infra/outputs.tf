#-------------
# outputs.tf
#-------------

### Environment
output "environment" {
  value = var.env
}


### SG
output "sg_webdmz" {
  value = module.networking.sg_webdmz
}


### Bastion
output "ec2_bastion_public_ip" { 
  value       = module.networking.ec2_bastion_public_ip
}

output "ec2_bastion_instance_id" { 
  value       = module.networking.ec2_bastion_instance_id
}


### DB
output "this_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = module.db.this_rds_cluster_resource_id
}

output "this_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.db.this_rds_cluster_endpoint
}

output "this_rds_cluster_master_password" {
  description = "The master password"
  value       = module.db.this_rds_cluster_master_password
}

output "this_rds_cluster_port" {
  description = "The port"
  value       = module.db.this_rds_cluster_port
}

output "this_rds_cluster_master_username" {
  description = "The master username"
  value       = module.db.this_rds_cluster_master_username
}

