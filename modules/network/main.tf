# ACM certificate for the domain (must be in us-east-1)
data "aws_acm_certificate" "cert" {
  domain      = "www.afsalkhan.in"
  statuses    = ["ISSUED"]
  most_recent = true
}

# Route 53 zone for afsalkhan.in
data "aws_route53_zone" "zone" {
  name = "afsalkhan.in"
}

# CloudFront distribution with custom origin (static website endpoint)
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["afsalkhan.in", "www.afsalkhan.in"]

  origin {
    domain_name = "afsalkhan.in.s3-website-us-east-1.amazonaws.com"
    origin_id   = "s3-static-website-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-static-website-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "afsalkhan.in"
  }
}

# Route 53 record for root domain
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "afsalkhan.in"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route 53 record for www
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "www.afsalkhan.in"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}