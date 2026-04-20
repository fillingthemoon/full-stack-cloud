variable "project_name" {
  description = "Name for the ECS cluster and service"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where ECS will run"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for Fargate tasks"
  type        = list(string)
}

variable "container_image" {
  description = "The ECR image URI for the application"
  type        = string
}

variable "container_port" {
  description = "Port the application listens on inside the container"
  type        = number
}

variable "table_name" {
  description = "Name of the DynamoDB table for environment variables"
  type        = string
}

variable "table_arn" {
  description = "ARN of the DynamoDB table for IAM policy scoping"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the SDK and logging"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group for container logs"
  type        = string
}

variable "log_group_arn" {
  description = "The ARN of the CloudWatch log group for IAM scoping"
  type        = string
}