variable "backup_para" {
  type = object({
    plan_name  = string
    vault_name = string
    schedule   = string
    lifecycle  = number
  })
}

