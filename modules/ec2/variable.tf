variable "ec2_para" {
  type = object({
    vpc_id           = string
    public_subnet_id = list(string)
    sg_id            = string
    NameTag          = string
    instance_type    = string
    instance_count   = number
    key_name         = string
  })
}

variable "ebs_para" {
  type = object({
    volume_type           = string
    volume_size           = string
    delete_on_termination = bool
  })
}