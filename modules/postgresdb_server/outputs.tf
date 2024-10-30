# output the IP addresses of the VM
output "ec2_public_ip" {
  description = "Public IP address of ec2 instance"
  value       = aws_instance.postgresdb.public_ip
}

output "ec2_private_ip" {
  description = "private IP address of ec2 instance"
  value       = aws_instance.postgresdb.private_ip
}

