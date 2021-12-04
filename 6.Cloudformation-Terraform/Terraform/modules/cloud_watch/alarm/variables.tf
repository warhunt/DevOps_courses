variable "alarms" {
  type = map(object({
    alarm_name          = string
    comparison_operator = string
    threshold           = number
    alarm_actions       = set(string)
  }))
}

variable "dimensions" {
  type = map(string)
}

variable "vpc" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
  description = "VPC object"
}
