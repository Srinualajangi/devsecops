resource "aws_ecr_repository" "main" {
  for_each             = toset(var.ecr_repos)
  name                 = "${var.project_name}-${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = "${var.project_name}-${each.key}" }
}
