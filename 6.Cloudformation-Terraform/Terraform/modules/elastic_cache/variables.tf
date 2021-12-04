variable "elastic_cache_clusters" {
  type = map(object({
    name           = string
    engine         = string
    engine_version = string
    port           = number
    }
  ))
}

variable "subnets_ids" {
  type = list(string)
}

variable "vpc" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
  description = "VPC object"
}

variable "security_group_ids" {
  type = set(string)
}
