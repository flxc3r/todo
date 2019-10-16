output "public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "list_sg_allowed_to_connect_to_db_sg" {
  description = "SGs allowed to connect to database SGs"
  value = [aws_security_group.bastion.id, aws_security_group.webdmz.id]
}

output "list_db_sg" {
  description = "Database SGs"
  value = [aws_security_group.db.id]
}

### SG
output "sg_webdmz" {
  value = aws_security_group.webdmz.id
}


### Bastion

output "ec2_bastion_public_ip" { 
  value       = aws_instance.bastion.public_ip
}

output "ec2_bastion_instance_id" { 
  value       = aws_instance.bastion.id
}