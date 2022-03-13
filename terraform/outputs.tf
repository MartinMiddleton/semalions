output "name_servers" {
  value = "${aws_route53_zone.zone.name_servers}"
}

output "origin_domain_name" {
  value = "${aws_s3_bucket.root_domain.website_endpoint}"
}
