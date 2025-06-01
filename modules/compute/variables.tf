variable "subnet_ids" {
  description = "Map of subnet names to their IDs from network module"
  type        = map(string)
}

variable "vm_details" {
  type = map(object({
    machine_type = string
    disk_size    = number
    zone         = string
    subnet_name  = string
    tags         = list(string)
    labels       = map(string)
  }))
}
