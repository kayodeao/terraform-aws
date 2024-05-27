# Define an S3 bucket resource named "mybucket"
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name
}

# Define ownership controls for the S3 bucket
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Define public access block settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Define access control list (ACL) for the S3 bucket
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# Define an S3 object resource for the index.html file
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

# Define an S3 object resource for the error.html file
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

# Define an S3 object resource for the profile image
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "19CG026396b (1).jpg"
  source = "19CG026396b (1).jpg"
  acl    = "public-read"
}

# Define website configuration for the S3 bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  # Ensure ACLs are applied before configuring website
  depends_on = [aws_s3_bucket_acl.example]
}
