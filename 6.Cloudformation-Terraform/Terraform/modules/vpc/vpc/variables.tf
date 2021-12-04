variable "cidr_block" {
  type        = string
  description = "CIDR block for vpc"
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "name" {
  type = string
}
