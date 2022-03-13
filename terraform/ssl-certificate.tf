// ACM certificate has to be in us-east-1 in order to work with CloudFront
// SSL certificate covering primary and secondary domains
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.root_domain}"
  validation_method = "EMAIL"

  subject_alternative_names = ["${var.www_domain}"]

  tags {
    Name = "${var.root_domain}"
  }
}

// Wait for domain validation to complete
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"

  // validation_record_fqdns = [
  //   "${aws_route53_record.primary_validation.fqdn}",
  //   "${aws_route53_record.secondary_validation.fqdn}",
  // ]
}
