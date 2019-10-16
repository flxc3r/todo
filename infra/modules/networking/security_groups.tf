#--------------------------
#  WebDMZ, bastion and DB
#--------------------------


resource "aws_security_group" "webdmz" {
  name        = "${var.vpc_name}-webdmz-${var.env}-sg"
  description = "WebDMZ"
  vpc_id = module.vpc.vpc_id

  # https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # http
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH from bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  # all
  egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    environment = var.env
    billing_category = "cross-project"
  }
}


resource "aws_security_group" "bastion" {
  name        = "${var.vpc_name}-bastion-${var.env}-sg"
  description = "bastion sg"
  vpc_id = module.vpc.vpc_id

  # all TCP from allowed CIDR blocks (i.e. home)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.allowed_bastion_ip_cidr_list
    description = "Bastion from home IP"
  }

  # all
  egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    environment = var.env
    billing_category = "cross-project"
  }
}



resource "aws_security_group" "db" {
  name        = "${var.vpc_name}-db-${var.env}-sg"
  description = "MySQL and PostreSQL sg"
  vpc_id = module.vpc.vpc_id

  # MySQL
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.webdmz.id, aws_security_group.bastion.id]
    self = true
    description = "MySQL from WebDMZ+Bastion+self"
  }

  # PostgreSQL
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.webdmz.id, aws_security_group.bastion.id]
    self = true
    description = "PostgreSQL from WebDMZ+Bastion+self"
  }

  # all
  egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    environment = var.env
    billing_category = "cross-project"
  }
}