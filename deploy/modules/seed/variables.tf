variable "env" {
  description = "Deployment Environment"
}

variable "project" {
  description = "Project name"
}

variable "vpc_id" {
  description = "The vpc id for the project"
}

variable "igw_id" {
  description = "The id of the internet gatewy used by the project"
}

variable "subnet_cidr" {
  description = "The cidr for the subnet"
}

variable "ssh_private_key_path" {
  description = "path to private SSH key file"
  type        = string
}

variable "tls_certificate_email" {
  description = "email to send to letsencrypt for tls certificates"
}

variable "num_instances" {
  description = "the number of instances"
  type        = number
}

variable "ami" {
  description = "the ami to use for instances"
}

variable "validator_ips" {
  description = "the ip addresses of the validator nodes"
}

variable "genesis_file_available" {
  description = "true if the genesis file is available"
  type        = bool
}

variable "dns_zone_id" {
  description = "id of route53 dns zone"
}

variable "dns_zone_name" {
  description = "fully qualified domain of route53 dns zone"
}

variable "token_name" {
  description = "name of the blockhain's token, eg MYTOKEN"
}
