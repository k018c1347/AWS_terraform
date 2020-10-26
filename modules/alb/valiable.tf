variable "alb_base_config" {
  type = object({
    public_subnet_id           = list(string)
    sg_id                      = string
    NameTag                    = string
    enable_deletion_protection = string
  })
}
variable "alb_target_config" {
  type = object({
    port        = string
    protocol    = string
    vpc_id      = string
    path        = string
    instance_id = any
  })
}
