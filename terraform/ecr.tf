resource "aws_ecr_repository" "app" {
  name = "fintech-app-repo"
}
output "ecr_uri" {
  value = aws_ecr_repository.app.repository_url
}
