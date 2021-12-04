
variable "name" {
  type = string
}

variable "internet_gateway_id" {
  type = string
}

variable "vpc" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
  description = "VPC object"
}

variable "subnet_ids" {
  type        = map(string)
  description = "map of subnet_id"
}
