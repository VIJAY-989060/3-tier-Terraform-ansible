variable "db_name" { type = string }
variable "db_instance_class" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  description = "The password for the RDS database master user."
  type        = string
  sensitive   = true
}
variable "vpc_security_group_ids" { type = list(string) }
variable "db_subnet_group_name" { type = string }
