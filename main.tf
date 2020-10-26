provider "aws" {
  region = "ap-southeast-1"
}

module vpc {
  source = "./modules/vpc"

  vpc_para = {
    NameTag              = "Terraform-minami"
    cidr_block           = "10.2.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    subnet_count         = 2
  }

}


module ec2_sg {
  source = "./modules/security_group"

  sg_para = {
    name        = "sg"
    vpc_id      = module.vpc.vpc_id
    protocol    = "tcp"
    port        = [22, 80, 443]
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module ec2 {
  source = "./modules/ec2"

  ec2_para = {
    vpc_id           = module.vpc.vpc_id
    public_subnet_id = module.vpc.public_subnet_id
    sg_id            = module.ec2_sg.sg_id
    NameTag          = "Terraform"
    instance_type    = "t2.micro"
    instance_count   = 3
    key_name         = "cf-minami"
  }
  ebs_para = {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = false
  }
}

module alb_sg {
  source = "./modules/security_group"

  sg_para = {
    name        = "alb_sg"
    vpc_id      = module.vpc.vpc_id
    protocol    = "tcp"
    port        = [80, 443]
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module alb {
  source = "./modules/alb"

  alb_base_config = {
    public_subnet_id           = module.vpc.public_subnet_id
    sg_id                      = module.alb_sg.sg_id
    NameTag                    = "Terraform"
    enable_deletion_protection = false
  }

  alb_target_config = {
    port        = 80
    protocol    = "HTTP"
    vpc_id      = module.vpc.vpc_id
    path        = "/"
    instance_id = module.ec2.instance_id
  }
}

output "instance_ip" {
  value = module.ec2.instance_ip
}

