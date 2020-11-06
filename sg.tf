resource "aws_security_group" "general_servers_sg" {
    name        = "wp-primer-sg-general-${var.environment}"
    description = "general server security group allowing ssh access only"
    vpc_id      = var.vpc_id

    tags = {
        Name        = "wp-primer-sg-web-${var.environment}"
        Terraform   = "True"
        Service     = "private"
        Environment = var.environment
    }
}

resource "aws_security_group_rule" "general_ssh_ingress" {
    from_port           = 22
    protocol            = "tcp"
    security_group_id   = aws_security_group.general_servers_sg.id
    to_port             = 22
    type                = "ingress"
    cidr_blocks         = var.public_cidr
}

resource "aws_security_group_rule" "general_egress" {
    security_group_id   = aws_security_group.general_servers_sg.id
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = var.public_cidr
}