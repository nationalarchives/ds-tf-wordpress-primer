variable "environment" {
    default = ""
}

variable "service" {
    default = ""
}

variable "cost_centre" {
    default = ""
}

variable "owner" {
    default = ""
}

variable "created_by" {
    default = ""
}

variable "tag_name" {
    default = ""
}

variable "vpc_id" {
    default = ""
}

variable "public_cidr" {
    default = ""
}

variable "ami_id" {
    default = {}
}

variable "instance_type" {
    default = "t2.micro"
}

variable "public_ip" {
    default = false
}

variable "key_name" {
    description = "ssh key-pair name"
    default = ""
}

variable "subnet_id" {
    default = ""
}

variable "volume_size" {
    default = ""
}

variable "instance_profile" {
    default = ""
}
