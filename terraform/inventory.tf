resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    web_public_ip    = module.web_server.public_ip,
    app_private_ip   = module.app_server.private_ip,
    ssh_user         = "ubuntu",
    ssh_private_key  = var.ssh_private_key_path,
    db_endpoint      = module.database.db_endpoint,
    db_user          = var.db_user,
    db_pass          = var.db_pass,
    db_name          = var.db_name,
    app_private_ip_for_web_conf = module.app_server.private_ip
  })
  filename = "${path.root}/../ansible/inventory.ini"
}
