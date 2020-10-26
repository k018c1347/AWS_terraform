resource "aws_lb" "alb" {
  name                       = var.alb_base_config.NameTag
  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = var.alb_base_config.enable_deletion_protection
  security_groups            = [var.alb_base_config.sg_id]
  subnets                    = var.alb_base_config.public_subnet_id
}


resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.terraform_tg.arn
    type             = "forward"
  }
}




resource "aws_lb_target_group" "terraform_tg" {
  name     = var.alb_base_config.NameTag
  port     = var.alb_target_config.port
  protocol = var.alb_target_config.protocol
  vpc_id   = var.alb_target_config.vpc_id
}



resource "aws_lb_target_group_attachment" "ec2" {
  count            = length(var.alb_target_config.instance_id)
  target_group_arn = aws_lb_target_group.terraform_tg.arn
  target_id        = element(var.alb_target_config.instance_id, count.index)
  port             = 80
}
