variable "region" {
  description = "The AWS region in which to build the infrastructure"
}
variable "root_domain" {
  description = "The the root domain (also known as zone apex or naked domain)"
}

variable "www_domain" {
  description = "The name of your website (e.g. www.mysite.com) - yes, including the www"
}

variable "organization" {
  description = "The organization name used for tagging"
}

// variable "zone_id" {
//   description = "The ID of the zone created outside of terraform (with the AWS registrar)"
// }
