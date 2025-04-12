resource "aws_iam_user" "tfe" {
  name = "TFE"
}

resource "aws_iam_user_policy" "tfe_s3_access" {
  name = "TFEUserS3AccessPolicy"
  user = aws_iam_user.tfe.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowListBucket",
        Effect: "Allow",
        Action: "s3:ListBucket",
        Resource: var.s3_bucket_arn
      },
      {
        Sid: "AllowS3GetObject",
        Effect: "Allow",
        Action: "s3:GetObject",
        Resource: "${var.s3_bucket_arn}/*"
      },
      {
        Sid: "AllowS3PutObject",
        Effect: "Allow",
        Action: "s3:PutObject",
        Resource: "${var.s3_bucket_arn}/*"
      }
    ]
  })
}