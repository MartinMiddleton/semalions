terraform {
  backend "s3" {
    bucket = "websites-terraform-statelock"
    key    = "semalions/terraform.tfstate"
    region = "us-east-1"
  }
}
