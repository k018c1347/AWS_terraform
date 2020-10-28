
resource "aws_lb_target_group_attachment" "tg1" {
  target_group_arn = module.lb.tg_arn
  target_id        = module.ec2.instance_id["EC2-1a"]
  port             = 80

}

resource "aws_lb_target_group_attachment" "tg2" {
  target_group_arn = module.lb.tg_arn
  target_id        = module.ec2.instance_id["EC2-1c"]
  port             = 80

}


/*
resource "aws_lb" "alb" {
  name                       = local.NameTag
  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = local.enable_deletion_protection
  security_groups            = [module.alb_sg.sg_id]
  subnets                    = module.vpc.public_subnet_id
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
  name     = local.NameTag
  port     = local.port
  protocol = local.protocol
  vpc_id   = module.vpc.vpc_id
}


*/
/*
resource "aws_lb_target_group_attachment" "ec2" {
  count            = length(module.ec2.instance_id)
  target_group_arn = aws_lb_target_group.terraform_tg.arn
  target_id        = element(module.ec2.instance_id, count.index)
  port             = 80
}
*/




/*
resource "aws_lb_target_group_attachment" "tg1" {
  for_each         = module.ec2.instance_id
  target_group_arn = aws_lb_target_group.terraform_tg.arn
  target_id        = each.value
  port             = 80
  depends_on = [module.ec2.instance_id]
}
*/

/*
resource "aws_lb_target_group_attachment" "tg1" {
  for_each         = module.ec2.instance_id
  target_group_arn = aws_lb_target_group.terraform_tg.arn
  target_id        = each.value
  port             = 80
  depends_on = [module.ec2.instance_id]
}
*/
