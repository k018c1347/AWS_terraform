provider "aws" {
  region = "ap-southeast-1"
}


module vpc {
  source = "../modules/vpc"

  vpc_para = {
    NameTag              = "Terraform-minami"
    cidr_block           = "10.2.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    subnet_count         = 2
  }

}

module ec2_sg {
  source = "../modules/security_group/resource"

  sg_para_source = {
    name     = "sg"
    vpc_id   = module.vpc.vpc_id
    protocol = "tcp"
    //port        = [22, 80, 443]
    port = {
      "ssh"   = 22,
      "http"  = 80,
      "https" = 443
    }
    source = module.lb_sg.sg_id
  }
}

module ec2 {
  source = "../modules/ec2"

  ec2_para = {
    vpc_id           = module.vpc.vpc_id
    public_subnet_id = module.vpc.public_subnet_id
    sg_id            = module.ec2_sg.sg_id
    NameTag          = "Terraform"
    instance_type    = "t2.micro"
    instance_count   = ["EC2-1a", "EC2-1c"]
    key_name         = "cf-minami"
  }
  ebs_para = {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = false
  }
}

module lb_sg {
  source = "../modules/security_group/cidr_block"

  sg_para = {
    name     = "alb_sg"
    vpc_id   = module.vpc.vpc_id
    protocol = "tcp"
    //port        = [80, 443]
    port = {
      "http"  = 80,
      "https" = 443
    }
    cidr_blocks = ["0.0.0.0/0"]

  }


}


module lb {
  source = "../modules/alb"

  lb_base_config = {
    public_subnet_id           = module.vpc.public_subnet_id
    sg_id                      = module.lb_sg.sg_id
    NameTag                    = "Terraform"
    enable_deletion_protection = false
    access_logs_bucket         = module.s3_log_bucket.s3_bucket_id
  }
  lb_target_config = {
    port        = 80
    protocol    = "HTTP"
    vpc_id      = module.vpc.vpc_id
    path        = "/"
    instance_id = module.ec2.instance_id
  }
}

module backup {
  source = "../modules/aws_backup"
  backup_para = {
    plan_name  = "TerraformBackup"
    vault_name = "TerraformBackup1"
    schedule   = "cron(0 18 * * ? *)"

    lifecycle = 3
  }
}



module s3_log_bucket {

  source = "../modules/s3"

  s3_para = {
    bucket                 = "minamiterraformalblogs"
    acl                    = "private"
    force_destroy          = "false"
    lifecycle_rule_enabled = "true"
    lifecycle_rule_days    = "180"
  }

}
