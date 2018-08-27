resource "aws_config_configuration_recorder" "aws_config_recorder" {
  count = "${var.enable_aws_config}"
  name  = "terraform_config_recorder"

  recording_group = {
    include_global_resource_types = true
  }

  role_arn = "${aws_iam_role.aws_config_iam_role.arn}"
}

resource "aws_config_configuration_recorder_status" "aws_config_recorder_status" {
  count      = "${var.enable_aws_config}"
  name       = "${aws_config_configuration_recorder.aws_config_recorder.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.aws_config_delivery_channel"]
}

resource "aws_s3_bucket" "aws_config_configuration_bucket" {
  count  = "${var.enable_aws_config}"
  bucket = "${data.aws_caller_identity.current.account_id}-terraform-aws-config-bucket"

  tags = "${merge(map("Project","shared"),
            map("ManagedBy","Terraform"),
            var.tags)}"
}

resource "aws_sns_topic" "aws_config_updates_topic" {
  count = "${var.enable_aws_config}"
  name  = "${data.aws_caller_identity.current.account_id}-terraform-aws-config-updates"
}

resource "aws_config_delivery_channel" "aws_config_delivery_channel" {
  count          = "${var.enable_aws_config}"
  name           = "terraform_aws_config_delivery_channel"
  s3_bucket_name = "${aws_s3_bucket.aws_config_configuration_bucket.bucket}"
  sns_topic_arn  = "${aws_sns_topic.aws_config_updates_topic.arn}"
  depends_on     = ["aws_s3_bucket.aws_config_configuration_bucket", "aws_sns_topic.aws_config_updates_topic"]
}

data "template_file" "aws_config_iam_assume_role_policy_document" {
  template = "${file("${path.module}/policies/aws_config_assume_role_policy.tpl")}"
}

resource "aws_iam_role" "aws_config_iam_role" {
  count              = "${var.enable_aws_config}"
  name               = "terraform-awsconfig-role"
  assume_role_policy = "${data.template_file.aws_config_iam_assume_role_policy_document.rendered}"
}

resource "aws_iam_role_policy_attachment" "aws_config_iam_policy_attachment" {
  count      = "${var.enable_aws_config}"
  role       = "${aws_iam_role.aws_config_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

data "template_file" "aws_config_iam_policy_document" {
  template = "${file("${path.module}/policies/aws_config_policy.tpl")}"

  vars {
    sns_topic_arn = "${aws_sns_topic.aws_config_updates_topic.arn}"
    s3_bucket_arn = "${aws_s3_bucket.aws_config_configuration_bucket.arn}"
  }
}

resource "aws_iam_role_policy" "aws_config_iam_policy" {
  count  = "${var.enable_aws_config}"
  name   = "terraform-awsconfig-policy"
  role   = "${aws_iam_role.aws_config_iam_role.id}"
  policy = "${data.template_file.aws_config_iam_policy_document.rendered}"
}

resource "null_resource" "sns_subscribe" {
  depends_on = ["aws_sns_topic.aws_config_updates_topic"]

  triggers = {
    sns_topic_arn = "${aws_sns_topic.aws_config_updates_topic.arn}"
  }

  count = "${length(var.aws_config_notification_emails) != 0 && var.enable_aws_config  ? length(var.aws_config_notification_emails) : 0 }"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${aws_sns_topic.aws_config_updates_topic.arn} --protocol email --notification-endpoint ${element(var.aws_config_notification_emails, count.index)}"
  }
}
