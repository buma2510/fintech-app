terraform {
  backend "s3" {
    bucket         = "bumy-fintechapp-state-bucket"
    key            = "ecs/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
