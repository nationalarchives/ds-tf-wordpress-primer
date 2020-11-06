output "instance_public_ip" {
    value = aws_instance.webapp_ec2.public_ip
}

output "instance_public_dns" {
    value = aws_instance.webapp_ec2.public_dns
}

output "instance_private_ip" {
    value = aws_instance.webapp_ec2.private_ip
}

output "instance_private_dns" {
    value = aws_instance.webapp_ec2.private_dns
}

output "instance_id" {
    value = aws_instance.webapp_ec2.id
}

output "instance_arn" {
    value = aws_instance.webapp_ec2.arn
}