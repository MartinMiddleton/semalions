# Terraform for S3 Static Website
This is a set of Terraform files to set up a static website in AWS. It makes use of the following AWS resources:

- S3
<!-- - Route53 -->
- CloudFront
- Certificate Manager

The end result is a website that supports:

- a primary and secondary domain (typically apex and www domains)
- HTTPS
- redirect from secondary to primary

Note that this setup does NOT use AWS Route53 to manage DNS.

Before the Amazon certificate authority (CA) can issue a certificate for your site, AWS Certificate Manager (ACM) must verify that you own or control all of the domains that you specified in your request. You can perform verification using either email or DNS. This configuration uses email validation.

ACM sends email messages to the three contact addresses listed in the WHOIS database and to five common system addresses for each domain that you specify. That is, up to eight email messages will be sent for every domain name and subject alternative name that you include in your request.
## Usage

1. Install Terraform (use `tfenv` to install 0.11.15)
1. Configure your AWS profile
1. `git clone git@github.com:alimac/terraform-s3-static-website.git`
1. `cd terraform-s3-static-website`
1. `terraform apply`
2. 

You will be prompted to provide values for primary and secondary domain.

In addition to typing values at the prompt, you can create a `terraform.tfvars` file:

```
root_domain = "example.com"
www_domain = "www.example.com"
```

If AWS is not your domain registrar, you will need to set your domain's name servers
to AWS name servers associated with your hosted zone. Terraform will output those
automatically:

```
Outputs:

name_servers = [
    ns-1500.awsdns-59.org,
    ns-1595.awsdns-07.co.uk,
    ns-619.awsdns-13.net,
    ns-63.awsdns-07.com
]
```

Note that in order to use a bucket name containing a period (i.e. example.com), you MUST modify your AWS configuration and specifically set the following:

```
use_accelerate_endpoint = false
```
in order to upload files to the bucket.

Otherwise, you'll see the following error when trying to deploy to the S3 bucket:
`fatal error: Bucket named example.com is not DNS compatible. Virtual hosted-style addressing cannot be used. The addressing style can be configured by removing the addressing_style value or setting that value to 'path' or 'auto' in the AWS Config file or in the botocore.client.Config object.`