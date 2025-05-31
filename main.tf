module "network" {
  source = "./modules/network"

  region = var.default_region
  vpc_name = var.vpc_name
  subnet_details = var.subnet_map
  cloud_router = var.cloud_router
  cloud_nat = var.cloud_nat
}

