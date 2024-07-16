output "my_wesite_domain" {
  value = aws_route53_zone.primary.name
}

output "websit_domain_name"{
    value = aws_route53_record.flask-app.name
}