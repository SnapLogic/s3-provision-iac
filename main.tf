provider "aws" {
    region = "${local.region}"
}

locals {
    bucket_name = var.bucket_name
    region = "${var.region}"
}

/* provision the bucket */
resource "aws_s3_bucket" "test1" {
    bucket = "${local.bucket_name}"
}

# /* bucket policy */
# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   bucket = aws_s3_bucket.test_bucket.id
# }