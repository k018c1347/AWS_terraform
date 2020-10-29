/*
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
*/




resource "aws_security_group" "sg" {
  name   = var.sg_para_source.name
  vpc_id = var.sg_para_source.vpc_id

}




/*
resource "aws_security_group_rule" "sg-ingress" {
  count             = length(var.sg_para.port)
  security_group_id = aws_security_group.sg.id
  type              = "ingress"

  from_port = var.sg_para.port[count.index]
  to_port   = var.sg_para.port[count.index]

  protocol    = var.sg_para.protocol
  cidr_blocks = var.sg_para.cidr_blocks

}
*/



resource "aws_security_group_rule" "sg-ingress_source" {

  for_each          = var.sg_para_source.port
  security_group_id = aws_security_group.sg.id
  type              = "ingress"

  from_port = each.value
  to_port   = each.value

  protocol                 = var.sg_para_source.protocol
  source_security_group_id = var.sg_para_source.source

}


resource "aws_security_group_rule" "sg-egress" {
  security_group_id = aws_security_group.sg.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "all"
}
