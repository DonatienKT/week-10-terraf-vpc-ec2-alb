terraform {
  backend "s3" {
    bucket         = "week10-kt-terraf"
    key            = "week10/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "week10-lock-state"
  }
}
