variable "project_name" {
  description = "Prefix for API Gateway resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "Subnets for the VPC Link"
  type        = list(string)
}

variable "vpc_link_sg_id" {
  description = "Security group for the VPC Link"
  type        = string
}

variable "load_balancer_listener_arn" {
  description = "ARN of the internal Load Balancer or Service Discovery"
  type        = string
}