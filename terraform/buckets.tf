// Bucket for website logs
resource "aws_s3_bucket" "logs" {
  bucket = "${var.root_domain}-site-logs"
  acl    = "log-delivery-write"

  tags = {
    Organization = "${var.organization}"
  }
}

// S3 bucket for hosting static website
resource "aws_s3_bucket" "root_domain" {
  bucket = "${var.root_domain}"

  logging {
    target_bucket = "${aws_s3_bucket.logs.bucket}"
    target_prefix = "${var.root_domain}/"
  }

  website {
    index_document = "index.md.html"
    error_document = "404.html"
  }

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.root_domain}/*"]
    }
  ]
}
POLICY

  // cors_rule {
  //   allowed_headers = ["*"]
  //   allowed_methods = ["GET", "HEAD"]
  //   // allowed_methods = ["GET", "PUT"]
  //   allowed_origins = ["https://${var.www_domain}", "https://${var.root_domain}"]
  //   // expose_headers  = ["ETag"]
  //   max_age_seconds = 3000
  // }

  tags = {
    Organization = "${var.organization}"
  }
}

// S3 bucket for redirection
resource "aws_s3_bucket" "www_domain" {
  bucket = "${var.www_domain}"

  website {
    redirect_all_requests_to = "https://${var.root_domain}"
  }

  tags = {
    Organization = "${var.organization}"
  }
}

// Hello, world HTML file
// resource "aws_s3_bucket_object" "index_html" {
//   bucket       = "${aws_s3_bucket.root_domain.id}"
//   key          = "index.html"
//   source       = "index.html"
//   acl          = "public-read"
//   content_type = "text/html"
// }
