resource "aws_security_group" "sg" {
  name   = var.sg_para.name
  vpc_id = var.sg_para.vpc_id

  dynamic "ingress" {
    for_each = var.sg_para.port

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.sg_para.protocol
      cidr_blocks = var.sg_para.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



