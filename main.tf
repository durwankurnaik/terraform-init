locals {
  config = yamldecode(file("config/dev.yaml"))
}

module "network" {
  source = "./modules/network"

  region         = var.default_region
  vpc_name       = local.config.network.vpc_name
  subnet_details = local.config.network.subnet_map
  cloud_router   = local.config.network.cloud_router
  cloud_nat      = local.config.network.cloud_nat
}

module "compute" {
  source = "./modules/compute"

  vm_details = local.config.compute.vms
  subnet_ids = module.network.subnet_ids

  depends_on = [module.network]
}

