resource "aws_config_config_rule" "require_tag_rule" {
  count = var.enable_aws_config && var.tag1Key != "" && var.enable_rule_require_tag ? 1 : 0
  name  = "require_tag"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = <<PARAMS
{
    "tag1Key": "${var.tag1Key}"
}

  PARAMS

  scope {
    compliance_resource_types = [
      "AWS::ACM::Certificate",
      "AWS::AutoScaling::AutoScalingGroup",
      "AWS::CloudFormation::Stack",
      "AWS::CodeBuild::Project",
      "AWS::DynamoDB::Table",
      "AWS::EC2::CustomerGateway",
      "AWS::EC2::Instance",
      "AWS::EC2::InternetGateway",
      "AWS::EC2::NetworkAcl",
      "AWS::EC2::NetworkInterface",
      "AWS::EC2::RouteTable",
      "AWS::EC2::SecurityGroup",
      "AWS::EC2::Subnet",
      "AWS::EC2::Volume",
      "AWS::EC2::VPC",
      "AWS::EC2::VPNConnection",
      "AWS::EC2::VPNGateway",
      "AWS::ElasticLoadBalancing::LoadBalancer",
      "AWS::ElasticLoadBalancingV2::LoadBalancer",
      "AWS::RDS::DBInstance",
      "AWS::RDS::DBSecurityGroup",
      "AWS::RDS::DBSnapshot",
      "AWS::RDS::DBSubnetGroup",
      "AWS::RDS::EventSubscription",
      "AWS::Redshift::Cluster",
      "AWS::Redshift::ClusterParameterGroup",
      "AWS::Redshift::ClusterSecurityGroup",
      "AWS::Redshift::ClusterSnapshot",
      "AWS::Redshift::ClusterSubnetGroup",
      "AWS::S3::Bucket",
    ]
  }

  depends_on = [
    aws_config_configuration_recorder.aws_config_recorder,
    aws_config_delivery_channel.aws_config_delivery_channel,
  ]
}

resource "aws_config_config_rule" "require_root_account_MFA_enabled_rule" {
  count = var.enable_aws_config && var.enable_rule_require_root_account_MFA ? 1 : 0
  name  = "require_root_account_mfa_enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = [
    aws_config_configuration_recorder.aws_config_recorder,
    aws_config_delivery_channel.aws_config_delivery_channel,
  ]
}

resource "aws_config_config_rule" "cloud_trail_enabled_rule" {
  count = var.enable_aws_config && var.enable_rule_require_cloud_trail ? 1 : 0
  name  = "cloud_trail_enabled"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }

  depends_on = [
    aws_config_configuration_recorder.aws_config_recorder,
    aws_config_delivery_channel.aws_config_delivery_channel,
  ]
}

resource "aws_config_config_rule" "iam_password_policy_rule" {
  count = var.enable_aws_config && var.enable_rule_iam_password_policy ? 1 : 0
  name  = "iam_password_policy"

  input_parameters = <<POLICY
{
    "RequireUppercaseCharacters": "${var.require_uppercase_characters}",
    "RequireLowercaseCharacters": "${var.require_lowercase_characters}",
    "RequireSymbols": "${var.require_symbols}",
    "RequireNumbers": "${var.require_numbers}",
    "MinimumPasswordLength": "${var.minimum_password_length}",
    "PasswordReusePrevention": "${var.password_reuse_prevention}",
    "MaxPasswordAge": "${var.max_password_age}"
}
  POLICY

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }

  depends_on = [
    aws_config_configuration_recorder.aws_config_recorder,
    aws_config_delivery_channel.aws_config_delivery_channel,
  ]
}
