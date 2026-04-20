variable "aws_region" {
  description = "The AWS region where all resources will be provisioned."
  type        = string
}

variable "project_name" {
  description = "A unique name for the project, used to prefix all resource names."
  type        = string
}

variable "container_image" {
  description = "The URI of the Docker image in ECR (e.g., 123456789012.dkr.ecr.ap-southeast-1.amazonaws.com/notes-app:latest)."
  type        = string
}

variable "container_port" {
  description = "The port the Node.js application is listening on."
  type        = number
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "log_retention_days" {
  description = "How many days to keep application and infrastructure logs in CloudWatch."
  type        = number
}
