// Hosted zone in Route53
// We want AWS to host our zone so its nameservers can point to our CloudFront
// distribution.
// Note: The domain was registered with AWS prior to running this.

// If you previously created the domain, use the section below.
// You will also need to make sure that all references to
// "aws_route53_zone.zone", instead reference "data.data.aws_route53_zone.zone"

// data "aws_route53_zone" "zone" {
//   zone_id = "${var.zone_id}"
//
//   tags = {
//     Organization = "${var.organization}"
//   }
// }

// If you are creating the domain via terraform, use this section.
resource "aws_route53_zone" "zone" {
  name = "${var.root_domain}"

  tags = {
    Organization = "${var.organization}"
  }
}

// Primary domain DNS record
resource "aws_route53_record" "root_domain" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  allow_overwrite = true
  name    = "${var.root_domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.root_domain.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.root_domain.hosted_zone_id}"
    evaluate_target_health = false
  }
}

// Secondary domain DNS record
resource "aws_route53_record" "www_domain" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  allow_overwrite = true
  name    = "${var.www_domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.www_domain.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.www_domain.hosted_zone_id}"
    evaluate_target_health = false
  }
}

// // Domain validation record - primary domain
// resource "aws_route53_record" "primary_validation" {
//   zone_id = "${aws_route53_zone.zone.zone_id}"
//   name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
//   type    = "CNAME"
//   ttl     = "60"
//   records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
// }
//
// // Domain validation record - secondary domain
// resource "aws_route53_record" "secondary_validation" {
//   zone_id = "${aws_route53_zone.zone.zone_id}"
//   name    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
//   type    = "CNAME"
//   ttl     = "60"
//   records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
// }

// MX record - Point to Google Domains, where the email is being handled"
resource "aws_route53_record" "mx" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name = "${aws_cloudfront_distribution.root_domain.domain_name}"
  // zone = "example.com."
  type = "MX"
  ttl  = 300

  records = [
    "5 gmr-smtp-in.l.google.com.",
    "10 alt1.gmr-smtp-in.l.google.com.",
    "20 alt2.gmr-smtp-in.l.google.com.",
    "30 alt3.gmr-smtp-in.l.google.com.",
    "40 alt4.gmr-smtp-in.l.google.com.",
  ]

  // depends_on = [
  //   "dns_a_record_set.smtp",
  //   "dns_a_record_set.backup",
  // ]
}
