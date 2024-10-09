terraform {
  backend "s3" {
    bucket = "s3-for-terraform-state-file1"  # Replace with your actual bucket name
    key    = "tf-state" # Specify the key (path) in the bucket for the state file
    region = "us-east-1"              # Replace with your desired AWS region
  }
}


