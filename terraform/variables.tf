variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "key_name" {
  description = "AWS EC2 Key Pair name"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Local path to the SSH private key"
  type        = string
}

variable "ec2_ami" {
  description = "AMI for EC2 instances"
  type        = string
}

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_user" {
  description = "RDS master username"
  type        = string
}

variable "db_pass" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
