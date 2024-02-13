resource "aws_cloudwatch_log_group" "test_app_log_group" {
  name = var.log_group_name

  tags = {
    Name = "${var.log_group_name}"
  }
}
