resource "aws_iam_group" "read-only-group" {
  count = var.enable_read_only_group ? 1 : 0
  name  = var.read_only_group_name
}

resource "aws_iam_group_policy_attachment" "read-only-policy-attachment" {
  count      = var.enable_read_only_group ? 1 : 0
  group      = aws_iam_group.read-only-group[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
