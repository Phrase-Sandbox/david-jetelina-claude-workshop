variable "bucket_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "enable_versioning" {
  type    = bool
  default = false
}

variable "lifecycle_rules_enabled" {
  type    = bool
  default = true
}

variable "transition_ia_days" {
  type    = number
  default = 30
}

variable "transition_glacier_days" {
  type    = number
  default = 90
}

variable "expiration_days" {
  type    = number
  default = 365
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "tofu"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Versioning configuration
resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle rules for cost optimization
# Run `terraform plan` to verify transitions before applying
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.lifecycle_rules_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "transition-to-cold-storage"
    status = "Enabled"

    transition {
      days          = var.transition_glacier_days
      storage_class = "GLACIER"
    }

    transition {
      days          = var.transition_ia_days
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = var.expiration_days
    }
  }
}

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "versioning_enabled" {
  value = var.enable_versioning
}
