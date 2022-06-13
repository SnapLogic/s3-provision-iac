provider "aws" {
    region = "${local.region}"
}

locals {
    bucket_name = var.bucket_name
    region = "${var.region}"
}

/* provision the bucket */
resource "aws_s3_bucket" "test_bucket" {
    bucket = "${local.bucket_name}"
}

