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

variable "load_balancers" {
  type = list(string)
}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "scaling_policyes" {
  type = map(object({
    name               = string
    scaling_adjustment = number
  }))
}
