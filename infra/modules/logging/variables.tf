variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain logs (Standard: 14)"
  type        = number
}
