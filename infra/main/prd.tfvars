aws_region   = "ap-southeast-1"
project_name = "notes-internal-api"

vpc_cidr = "10.0.0.0/16"

container_image = "123456789012.dkr.ecr.ap-southeast-1.amazonaws.com/notes-app-prd:latest"
container_port  = 3000

log_retention_days = 30