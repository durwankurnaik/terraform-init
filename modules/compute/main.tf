# Generate SSH key pair for bastion communication
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private key locally (optional, for backup/debugging)
resource "local_file" "bastion_private_key" {
  content         = tls_private_key.bastion_key.private_key_pem
  filename        = "${path.module}/bastion-key.pem"
  file_permission = "0600"
}

# Store public key locally (optional, for reference)
resource "local_file" "bastion_public_key" {
  content  = tls_private_key.bastion_key.public_key_openssh
  filename = "${path.module}/bastion-key.pub"
}

# Image details
data "google_compute_image" "ubuntu_image" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

# External Disk, will be configured later

# Virtual Machine
resource "google_compute_instance" "virtual_machines" {
  for_each = var.vm_details

  name         = each.key
  machine_type = each.value.machine_type
  zone         = each.value.zone

  tags   = each.value.tags
  labels = each.value.labels

  boot_disk {
    initialize_params {
      image  = data.google_compute_image.ubuntu_image.self_link
      size   = var.vm_details[each.key].disk_size
      type   = "pd-ssd"
      labels = var.vm_details[each.key].labels
    }

    mode = "READ_WRITE"
  }

  # attached_disk {
  #   source      = google_compute_disk.external_disk[each.key].id
  #   device_name = "${each.key}-external-disk"
  # }

  network_interface {
    subnetwork = var.subnet_ids[each.value.subnet_name]
  }

  deletion_protection = false # When you want to delete the infra, first modify this variable and make it false

  # Add SSH key for all VMs
  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.bastion_key.public_key_openssh}"
  }

  # Different startup scripts based on VM name containing "bastion"
  metadata_startup_script = can(regex("bastion", lower(each.key))) ? templatefile("${path.module}/scripts/bastion-startup.sh", {
    private_key = tls_private_key.bastion_key.private_key_pem
  }) : null
}
