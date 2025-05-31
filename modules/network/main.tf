# Networking configuration includes VPC, Subnet, Cloud router, Cloud NAT and Firewalls


# Virtual Private Cloud (VPC)
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false # these will be created in below configuration
}


# Subnets
resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnet_details

  name          = each.key
  ip_cidr_range = each.value.cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.id
}


# Cloud Router
resource "google_compute_router" "router" {
  name    = var.cloud_router
  region  = var.region
  network = google_compute_network.vpc_network.id

  depends_on = [google_compute_network.vpc_network]
}


# Cloud NAT
resource "google_compute_router_nat" "cloud_nat" {
  name                               = var.cloud_nat
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnets["terraform-dev-snet-pub"].name
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }

  depends_on = [google_compute_router.router]
}


# Firewall Rules
resource "google_compute_firewall" "deny_internal_subnet_traffic" {
  name    = "deny-internal-subnet-traffic"
  network = google_compute_network.vpc_network.name

  direction = "INGRESS"
  priority  = 1000

  # all the subnets as source and destination
  source_ranges      = [for snet in keys(var.subnet_details) : var.subnet_details[snet].cidr_range]
  destination_ranges = [for snet in keys(var.subnet_details) : var.subnet_details[snet].cidr_range]

  deny {
    protocol = "all"
  }

  description = "Deny all traffic betweent subnets in the VPC"
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc_network.name

  direction = "INGRESS"
  priority  = 900

  source_ranges      = ["35.235.240.0/20"] # default range used by google to provide access via IAP
  destination_ranges = [var.subnet_details["terraform-dev-snet-pub"].cidr_range]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  description = "Allow IP range used by google for the IAP based ssh access to VM's"
}

resource "google_compute_firewall" "allow_internal_ssh" {
  name    = "allow-internal-ssh"
  network = google_compute_network.vpc_network.name

  direction = "INGRESS"
  priority  = 901

  source_ranges = [var.subnet_details["terraform-dev-snet-pub"].cidr_range]
  destination_ranges = [
    for snet in keys(var.subnet_details) :
    var.subnet_details[snet].cidr_range
    if snet != "terraform-dev-snet-pub"
  ]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  description = "Internal SSH from bastion VM's to other subnets"
}
