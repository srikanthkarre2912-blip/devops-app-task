terraform {
  backend "s3" {
    bucket = "task-devops0370"
    key    = "devopstask/terraform.tfstate"
    region = "us-east-1"
  }
}
