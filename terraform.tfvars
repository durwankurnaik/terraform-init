# global variables
project_id = "jiomeet-vidyo"
default_region = "asia-south1"
default_zone = "asia-south1-a"

# networking variables
vpc_name = "terraform-dev-vpc"
subnet_map = {
  "terraform-dev-snet-pub" = {
    cidr_range = "10.0.0.0/28"
  }
  "terraform-dev-snet-app" = {
    cidr_range = "10.0.1.0/24"
  }
  "terraform-dev-snet-db" = {
    cidr_range = "10.0.2.0/24"
  }
}
cloud_router = "terraform-dev-router"
cloud_nat = "terraform-dev-nat"

# compute variables
