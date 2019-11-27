data "aws_iam_policy_document" "monitor_readonly_user_policy_document" {
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

resource "aws_iam_policy" "monitor_readonly_user_policy" {
  count       = var.enable_monitor_readonly_user ? 1 : 0
  name        = "terraform-monitor-readonly-policy"
  description = "Gives readonly access to monitor and tags (e.g. for grafana)"
  policy      = data.aws_iam_policy_document.monitor_readonly_user_policy_document.json
}

resource "aws_iam_user" "monitor_readonly_user" {
  count = var.enable_monitor_readonly_user ? 1 : 0
  name  = var.monitor_readonly_user_name
}

resource "aws_iam_access_key" "monitor_readonly_user_access_key" {
  count = var.enable_monitor_readonly_user ? 1 : 0
  user  = aws_iam_user.monitor_readonly_user[0].name
}
