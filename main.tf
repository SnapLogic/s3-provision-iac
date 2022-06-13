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

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.test_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.test_bucket.arn,
      "${aws_s3_bucket.test_bucket.arn}/*",
    ]
  }
}

