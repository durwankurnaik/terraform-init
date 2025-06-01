output "name_to_internal_ip" {
  description = "Map of VM name to internal IP"
  value = {
    for name, instance in google_compute_instance.virtual_machines :
    name => instance.network_interface[0].network_ip
  }
}
