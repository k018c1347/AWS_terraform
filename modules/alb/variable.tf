variable "lb_base_config" {
  type = object({
    public_subnet_id           = list(string)
    sg_id                      = string
    NameTag                    = string
    enable_deletion_protection = string
    access_logs_bucket         = string
  })
}
variable "lb_target_config" {
  type = object({
    port     = string
    protocol = string
    vpc_id   = string
    path     = string
  })
}
