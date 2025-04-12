data "aws_ssoadmin_instances" "this" {}

resource "aws_ssoadmin_permission_set" "tfe" {
  name         = var.permission_set_name
  instance_arn = data.aws_ssoadmin_instances.this.arn
  description  = "Permission set for TFE with S3 access"
}

resource "aws_ssoadmin_permission_set_inline_policy" "s3_access" {
  instance_arn       = data.aws_ssoadmin_instances.this.arn
  permission_set_arn = aws_ssoadmin_permission_set.tfe.arn

  inline_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowListBucket",
        Effect   = "Allow",
        Action   = "s3:ListBucket",
        Resource = var.s3_bucket_arn
      },
      {
        Sid      = "AllowGetObject",
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "${var.s3_bucket_arn}/*"
      }
    ]
  })
}