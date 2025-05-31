variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_details" {
  type = map(object({
    cidr_range = string
  }))
}

variable "cloud_router" {
  type = string
}

variable "cloud_nat" {
  type = string
}
