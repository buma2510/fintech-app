terraform {
  backend "s3" {
    bucket         = "<bucket-unique-name>"
    key            = "ecs/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
