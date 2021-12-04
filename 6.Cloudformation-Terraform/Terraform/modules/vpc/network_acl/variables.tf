variable "name" {
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
  type        = set(string)
  description = "List of subnet_id"
}
