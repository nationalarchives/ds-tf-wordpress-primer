# WordPress Primer EC2 instance for AMI

This module creates an EC2 instance to make a WordPress ready AMI.
* LAMP Web Server on Amazon Linux 2
* WordPress core downloaded
* WP CLI
* NFS packages

## Usage

```hcl-terraform
module "app" {
    source = "git@github.com:nationalarchives/ds-tf-wordpress-primer//?ref=main"
    var_one = "foo"
    var_two = "bar"
}
```
 
1. To use a module from this repository, add a block like the above to your terraform code.
2. Ensure you have all the required inputs (see below).
3. Run `terraform init` to initiate and acquire the module.
5. Then run `terraform plan` and  `terraform apply`.
6. Log into the AWS console, go to EC2 instance, select the newly created EC2, go to `Actions > Image and Templates > Create image` to create the AMI

## Inputs

Name | Description | Example
------------ | ------------- | -------------
environment | Environment | dev
service | Service name | blog
owner | Service owner | Digital Services
created_by | Created by individual's email | jane.smith@example.com
cost_centre | Cost centre code | 99
vpc_id | VPC ID | `vpc-2f09a348`
subnet_id | Public subnet ID | `subnet-b46032ec` 
ami_id | AMI ID (Amazon Linux 2) | `ami-0271d331ac7dab654"`
key_name | Pair key name | `wp-primer`
public_cidr | Public CIDR list | `["0.0.0.0/0"]`
github_token | Github access token | 71d3310271d331ac7dab654ac7dab654
