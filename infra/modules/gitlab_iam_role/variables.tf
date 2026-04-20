variable "project_name" {
  type = string
}

variable "gitlab_project_path" {
  description = "Example: username/project-name"
  type        = string
}

variable "gitlab_branch" {
  description = "The branch allowed to deploy (e.g., main)"
  type        = string
}
