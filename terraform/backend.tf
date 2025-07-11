terraform {
  backend "s3" {
    bucket         = "bumy-fintechapp-state-bucket"
    key            = "ecs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
