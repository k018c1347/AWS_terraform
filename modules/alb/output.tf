output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "tg_arn" {
  value = aws_lb_target_group.terraform_tg.arn
}


