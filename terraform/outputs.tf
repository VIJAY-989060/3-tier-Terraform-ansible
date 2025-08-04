output "web_server_public_ip" { value = module.web_server.public_ip }
output "rds_endpoint" { value = module.database.db_endpoint }
output "ansible_inventory_path" { value = resource.local_file.ansible_inventory.filename }
