provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  project_name   = var.project_name
  vpc_cidr       = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
}

resource "aws_security_group" "web_sg" {
  name = "${var.project_name}-web-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name = "${var.project_name}-app-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name = "${var.project_name}-db-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "web_server" {
  source = "./modules/ec2"
  instance_name = "${var.project_name}-web"
  ami = var.ec2_ami
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnet_ids[0]
  security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name = var.key_name
}

module "app_server" {
  source = "./modules/ec2"
  instance_name = "${var.project_name}-app"
  ami = var.ec2_ami
  instance_type = "t2.micro"
  subnet_id = module.vpc.private_subnet_ids[0]
  security_group_ids = [aws_security_group.app_sg.id]
  associate_public_ip_address = false
  key_name = var.key_name
}

module "database" {
  source = "./modules/rds"

  db_name              = var.db_name
  db_instance_class    = "db.t3.micro"
  db_username          = var.db_user
  db_password          = var.db_pass # This line is the fix
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = module.vpc.db_subnet_group_name
}
