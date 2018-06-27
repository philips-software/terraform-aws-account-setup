data "template_file" "force_mfa" {
  count = "${var.enable_mfa ? 1 : 0}"

  template = "${file("${path.module}/policies/force-mfa.json")}"
}

resource "aws_iam_policy" "mfa" {
  count = "${var.enable_mfa ? 1 : 0}"

  name        = "ForceMFA"
  path        = "/"
  description = "Policy to enforce MFA"

  policy = "${data.template_file.force_mfa.rendered}"
}
