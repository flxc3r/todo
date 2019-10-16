resource "aws_key_pair" "public_key" {
  key_name   = "${var.vpc_name}_public_key_${var.env}"
  public_key = var.ssh_public_key
}

locals {
    instance-userdata = <<EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install httpd -y
        sudo service httpd start
        sudo chkconfig httpd on
        sudo mkdir /var/www/html/
        cd /var/www/html/
        sudo echo "instance-id: " > index.html
        curl http://169.254.169.254/latest/meta-data/instance-id >> index.html
        sudo echo "<br>" >> index.html
        sudo echo "security-groups: " >> index.html
        curl http://169.254.169.254/latest/meta-data/security-groups/ >> index.html
        EOF
}


# resource "aws_instance" "web" {
#   ami           = "ami-00c03f7f7f2ec15c3" # Amazon Linux 2 AMI on us-east-2
#   instance_type = "t2.micro"
#   subnet_id = module.vpc.public_subnets[0]
#   vpc_security_group_ids = [aws_security_group.webdmz.id]
#   key_name = aws_key_pair.public_key.key_name

#   user_data_base64 = "${base64encode(local.instance-userdata)}"

#   depends_on=[aws_key_pair.public_key]

#   tags = {
#     Name = "${var.vpc_name}-web"
#     environment = var.env
#     billing_category = "cross-project"
#   }
# }


resource "aws_instance" "bastion" {
  ami           = var.bastion_ami 
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name = aws_key_pair.public_key.key_name

  user_data_base64 = "${base64encode(local.instance-userdata)}"

  depends_on=[aws_key_pair.public_key]

  tags = {
    Name = "${var.vpc_name}-bastion-${var.env}"
    environment = var.env
    billing_category = "cross-project"
  }
}


# resource "aws_instance" "db" {
#   ami           = "ami-00c03f7f7f2ec15c3" # Amazon Linux 2 AMI on us-east-2
#   instance_type = "t2.micro"
#   subnet_id = module.vpc.public_subnets[0]
#   vpc_security_group_ids = [aws_security_group.db.id]
#   key_name = aws_key_pair.public_key.key_name

#   user_data_base64 = "${base64encode(local.instance-userdata)}"

#   depends_on=[aws_key_pair.public_key]

#   tags = {
#     Name = "${var.vpc_name}-db"
#     environment = var.env
#     billing_category = "cross-project"
#   }
# }
