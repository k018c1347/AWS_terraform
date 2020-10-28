output "instance_ip" {
  value = {
    for instances in aws_instance.ec2 :
    instances.tags.Name => instances.public_ip
  }
}

/*
output "instance_id" {
  value = aws_instance.ec2[*].id
}
*/

output "instance_id" {
  value = {
    for instance in aws_instance.ec2 :
    instance.tags.Name => instance.id
  }

  depends_on = [aws_instance.ec2.id]

}