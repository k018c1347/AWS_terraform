
resource "aws_lb" "alb" {
  name                       = var.lb_base_config.NameTag
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = var.lb_base_config.enable_deletion_protection
  subnets                    = var.lb_base_config.public_subnet_id
  security_groups            = [var.lb_base_config.sg_id]
  access_logs {
    bucket = var.lb_base_config.access_logs_bucket
    prefix = "/alb_logs"

  }
}



resource "aws_lb_target_group" "terraform_tg" {
  name                 = var.lb_base_config.NameTag
  port                 = var.lb_target_config.port
  protocol             = var.lb_target_config.protocol
  vpc_id               = var.lb_target_config.vpc_id
  deregistration_delay = "10"

  //スティッキーセッション	

  health_check {
    /*
    protocol            = var.lb_target_config.protocol
    path                = var.lb_target_config.path
    port                = var.lb_target_config.port
    */
    protocol            = "HTTP"
    path                = "/"
    port                = "80"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = 200
    //200以外も？

  }
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


data "aws_acm_certificate" "acm" {
  domain = "wingsuit.work"
}


resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.acm.arn
  //"${var.alb_config["certificate_arn"]}"


  default_action {
    target_group_arn = aws_lb_target_group.terraform_tg.arn
    type             = "forward"
  }
}



//aws_alb_listener_ruleも追加で
