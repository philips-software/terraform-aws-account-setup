data "aws_iam_policy_document" "cloudwatch_readonly_user_policy_document" {
  statement {
    sid = "AllowReadingMetricsFromCloudWatch"

    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:GetMetricData",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowReadingTagsInstancesRegionsFromEC2"

    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowReadingResourcesForTags"

    actions = [
      "tag:GetResources",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_readonly_user_policy" {
  count       = "${var.enable_cloudwatch_readonly_user}"
  name        = "terraform-cloudwatch-readonly-policy"
  description = "Gives readonly access to cloudwatch and tags (e.g. for grafana)"
  policy      = "${data.aws_iam_policy_document.cloudwatch_readonly_user_policy_document.json}"
}

resource "aws_iam_user" "cloudwatch_readonly_user" {
  count = "${var.enable_cloudwatch_readonly_user}"
  name  = "${var.cloudwatch_readonly_user_name}"
}

resource "aws_iam_access_key" "cloudwatch_readonly_user_access_key" {
  count = "${var.enable_cloudwatch_readonly_user}"
  user  = "${aws_iam_user.cloudwatch_readonly_user.name}"
}
