module "network" {
  source = "./modules/network"

  admin_ip_cidr = var.admin_ip_cidr
}

module "compute" {
  source = "./modules/compute"

  ssh_public_key      = var.ssh_public_key
  network_id          = module.network.network_id
  public_subnet_id    = module.network.public_subnet_id
  private_subnet_a_id = module.network.private_subnet_a_id
  private_subnet_b_id = module.network.private_subnet_b_id
  sg_bastion_id       = module.network.sg_bastion_id
  sg_web_id           = module.network.sg_web_id
  sg_alb_id           = module.network.sg_alb_id
}

module "monitoring" {
  source = "./modules/monitoring"

  ssh_public_key       = var.ssh_public_key
  private_subnet_a_id  = module.network.private_subnet_a_id
  public_subnet_id     = module.network.public_subnet_id
  sg_prometheus_id     = module.network.sg_prometheus_id
  sg_grafana_id        = module.network.sg_grafana_id
}