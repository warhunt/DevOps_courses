variable "vpc" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
  description = "VPC object"
}

variable "security_groups" {
  type = list(string)
}

variable "instances" {
  type = map(object({
    subnet_id = string
    name      = string
  }))
}
