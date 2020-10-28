
resource "aws_lb" "alb" {
  name                       = var.lb_base_config.NameTag
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = var.lb_base_config.enable_deletion_protection

  subnets = var.lb_base_config.public_subnet_id

  security_groups = [var.lb_base_config.sg_id]

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
  name                 = var.lb_base_config.NameTag
  port                 = var.lb_target_config.port
  protocol             = var.lb_target_config.protocol
  vpc_id               = var.lb_target_config.vpc_id
  deregistration_delay = "10"


  health_check {
    protocol            = var.lb_target_config.protocol
    path                = var.lb_target_config.path
    port                = var.lb_target_config.port
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = 200
  }
}
