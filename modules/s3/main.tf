resource "aws_s3_bucket" "website_bucket" {
  bucket        = "afsalkhan.in" 
  force_destroy = true

  tags = {
    Name = "afsalkhan.in"
  }
}
# Allow public accessing
resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}
# Make the bucket objects publicly readable
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.allow_public]
}

# Upload all files in ./staticfiles to the bucket

locals {
  static_files = fileset(var.static_dir_path, "**/*.*")
}

resource "aws_s3_object" "static_assets" {
  for_each = { for file in local.static_files : file => file }

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.key
  source = "${var.static_dir_path}/${each.value}"
  etag   = filemd5("${var.static_dir_path}/${each.value}")

  content_type = lookup({
    html = "text/html",
    css  = "text/css",
    js   = "application/javascript",
    png  = "image/png",
    jpg  = "image/jpeg"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "binary/octet-stream")
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}