locals {
  s3-logging = merge(
    {
      enabled          = false
      create_bucket    = true
      custom_bucket_id = null
    },
    var.s3-logging
  )
}

module "s3_logging_bucket" {
  create_bucket = local.s3-logging.enabled && local.s3-logging.create_bucket

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true

  bucket = "${var.cluster-name}-eks-addons-s3-logging"
  acl    = "private"

  versioning = {
    status = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}
