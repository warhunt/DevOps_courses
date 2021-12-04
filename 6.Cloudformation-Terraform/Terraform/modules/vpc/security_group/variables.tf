terraform {
  experiments = [module_variable_optional_attrs]
}

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

variable "description" {
  type = string
}

variable "ingresses" {
  type = map(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(set(string))
    security_groups = optional(set(string))
  }))
}

variable "egresses" {
  type = map(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(set(string))
    security_groups = optional(set(string))
  }))
}
