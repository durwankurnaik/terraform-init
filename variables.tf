variable "project_id" {
  type        = string
  default     = "jiomeet-vidyo"
}

variable "default_region" {
  type        = string
  default     = "asia-south1" # This is Mumbai region
}

variable "default_zone" {
  type        = string
  default     = "asia-south1-a"
}

variable "vpc_name" {
  type = string
}

variable "subnet_map" {
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
