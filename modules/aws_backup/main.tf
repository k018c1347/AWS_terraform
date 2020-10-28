data "aws_iam_role" "role" {
  name = "AWSBackupDefaultServiceRole"
}


resource "aws_backup_vault" "EC2" {
  //名前は変数にできそう
  name = var.backup_para.vault_name
}




resource "aws_backup_plan" "EC2" {
  name = var.backup_para.plan_name
  rule {
    rule_name         = "EC2"
    target_vault_name = aws_backup_vault.EC2.name
    //スケジュールは変数にできそう
    schedule = var.backup_para.schedule
    //"cron(0 18 * * ? *)"
    lifecycle {
      delete_after = var.backup_para.lifecycle
    }
  }
}

resource "aws_backup_selection" "EC2" {
  iam_role_arn = data.aws_iam_role.role.arn
  name         = "Tag-AWSBackup-EC2"
  plan_id      = aws_backup_plan.EC2.id

  //タグも変数にできそう
  selection_tag {
    type  = "STRINGEQUALS"
    key   = "AWSBackup"
    value = "EC2"
  }
}
