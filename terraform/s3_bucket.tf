# Creating S3 bucket
#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "bucket" {
  bucket        = "nehapatil.xyz"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "cors_policy" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }

}

resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}


resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.bucket_access_block]
  bucket     = aws_s3_bucket.bucket.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"

      }
    ]
  })
}

resource "aws_s3_object" "index" {
  for_each     = fileset("${path.module}/../content", "**/*.{html,css,js}")
  bucket       = aws_s3_bucket.bucket.id
  key          = replace(each.value, "^content/", "")
  source       = "${path.module}/../content/${each.value}"
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  source_hash  = filemd5("${path.module}/../content/${each.value}")
}


resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.bucket.id


  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}