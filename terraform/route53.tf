# Creating hosted zone
resource "aws_route53_zone" "primary" {
  name = "nehapatil.xyz"
}

# Adding ELB
resource "aws_route53_record" "flask-app" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "nehapatil.xyz"
  type    = "A"

  alias {
    name                   = aws_lb.web_elb.dns_name
    zone_id                = aws_lb.web_elb.zone_id
    evaluate_target_health = false
  }

  set_identifier = "Flask Application hosted on EC2"

  geolocation_routing_policy {
    country = "IN"
  }
}

# Adding S3 website
resource "aws_route53_record" "static-app" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "nehapatil.xyz"
  type    = "A"

  alias {
    name                   = "s3-website-us-east-1.amazonaws.com"
    zone_id                = aws_s3_bucket.bucket.hosted_zone_id
    evaluate_target_health = false
  }

  set_identifier = "Static Website hosted at S3"
  geolocation_routing_policy {
    continent = "EU"
  }
}