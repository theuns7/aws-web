resource "aws_ecr_repository" "repo" {
	name = "aws-web"

	image_scanning_configuration {
		scan_on_push = true
	}
}

output "repo_url" {
  value = aws_ecr_repository.repo.repository_url
}