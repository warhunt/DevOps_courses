variable "vpc" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
  description = "VPC object"
}

variable "name" {
  type = string
}

variable "instances" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}
