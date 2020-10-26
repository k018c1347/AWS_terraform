# 最新のAmazon Linux AMI IDを取得
data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "ec2" {
  count         = var.ec2_para.instance_count
  ami           = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = var.ec2_para.instance_type
  key_name      = var.ec2_para.key_name
  vpc_security_group_ids = [
    var.ec2_para.sg_id
  ]
  subnet_id = element(var.ec2_para.public_subnet_id, count.index % length(var.ec2_para.public_subnet_id))
  root_block_device {
    volume_type           = var.ebs_para.volume_type
    volume_size           = var.ebs_para.volume_size
    delete_on_termination = var.ebs_para.delete_on_termination
  }
  tags = {
    Name = "${var.ec2_para.NameTag}-instance${count.index}"
  }
}
