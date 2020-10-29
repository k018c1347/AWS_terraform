variable "sg_para" {
  type = object({
    name        = string
    vpc_id      = string
    protocol    = string
    port        = any
    cidr_blocks = list(string)

  })
}



