variable "subnets" {
  type = map(object({
    cidr_block              = string
    map_public_ip_on_launch = bool
    availability_zone       = string
    name                    = string
  }))
  description = "Subnets to create"
}

variable "vpc" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
  description = "VPC object"
}
