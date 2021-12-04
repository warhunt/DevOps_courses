variable "availability_zone" {
  type = string
}

variable "name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
  description = "VPC object"
}

variable "vpc_security_group_ids" {
  type = list(string)
}
