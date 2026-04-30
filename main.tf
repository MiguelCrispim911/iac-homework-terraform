module "network" {
  source = "./modules/network"

  name_prefix = local.name_prefix
}

module "compute" {
  source = "./modules/compute"

  name_prefix = local.name_prefix
  subnet_id   = module.network.public_subnet_id
  vpc_id      = module.network.vpc_id
  owner       = var.owner
  web_message = var.web_message
}
