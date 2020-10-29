resource "aws_s3_bucket" "log_bucket" {
  //name
  bucket = var.s3_para.bucket
  acl    = var.s3_para.acl
  //"private"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = var.s3_para.lifecycle_rule_enabled
    expiration {
      days = var.s3_para.lifecycle_rule_days

    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

/*
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.log_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}
*/


resource "aws_s3_bucket_policy" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.log_bucket.json
}

data "aws_iam_policy_document" "log_bucket" {

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["114774131450"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.s3_para.bucket}/*"]


  }
}

/*
resource "aws_s3_bucket" "force_destroy" {
  bucket        = aws_s3_bucket.log_bucket.id
  force_destroy = "false"

}

*/
