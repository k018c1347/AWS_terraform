variable "s3_para" {
  type = object({

    bucket                 = string
    acl                    = string
    force_destroy          = string
    lifecycle_rule_enabled = string
    lifecycle_rule_days    = string

  })
}


