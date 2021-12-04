variable "name" {
  type        = string
  description = "Name for internet gateway"
}

variable "vpc" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
  description = "VPC object"
}
