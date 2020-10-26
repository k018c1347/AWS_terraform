output "instance_ip" {
  value = {
    for instance in aws_instance.ec2[*] :
    instance.tags.Name => instance.public_ip
  }
}
output "instance_id" {
  value = aws_instance.ec2[*].id
}
