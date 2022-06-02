terraform {
  backend "s3" {
    bucket = "my-s3bucket-20220602053941137200000001"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "db-terraform"
    encrypt = true
  }
}