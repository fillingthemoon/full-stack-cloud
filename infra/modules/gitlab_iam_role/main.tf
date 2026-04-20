resource "aws_iam_openid_connect_provider" "gitlab" {
  url             = "https://gitlab.com"
  client_id_list  = ["https://gitlab.com"]
  thumbprint_list = ["b3dd7606d2b5a752847ee45d925c51e4ad4e7f38"] 
}

resource "aws_iam_role" "gitlab_ci" {
  name = "${var.project_name}-gitlab-ci-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.gitlab.arn
        }
        Condition = {
          StringLike = {
            "gitlab.com:sub": "project_path:${var.gitlab_project_path}:ref_type:branch:ref:${var.gitlab_branch}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "gitlab_admin" {
  role       = aws_iam_role.gitlab_ci.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}