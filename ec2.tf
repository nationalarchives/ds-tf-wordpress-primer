resource "aws_instance" "wp_primer" {
    ami                         = var.ami_id
    associate_public_ip_address = var.public_ip
    instance_type               = var.instance_type
    key_name                    = var.key_name
    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = [
        aws_security_group.general_servers_sg.id
    ]

    root_block_device {
        volume_size = var.volume_size
        encrypted   = true
    }
    
    user_data            = data.template_file.ec2_user_data.rendered

    tags = {
        Name        = var.tag_name
        Environment = var.environment
        Terraform   = "true"
    }
}

data "template_file" "ec2_user_data" {
    template = file("${path.module}/script/wp_ec2.sh")

    vars = {
        environment  = var.environment
        github_token = var.github_token
    }
}