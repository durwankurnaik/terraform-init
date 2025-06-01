output "vpc_id" {
  value = google_compute_network.vpc_network.id
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    for name, subnet in google_compute_subnetwork.subnets :
    name => subnet.id
  }
}
