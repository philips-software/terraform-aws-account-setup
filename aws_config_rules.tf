resource "aws_config_config_rule" "require_project_tag_rule" {
  count = "${var.enable_aws_config}" 
  name = "require_project_tag"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }
    input_parameters = "{\"tag1Key\": \"Project\"}"
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
                "AWS::S3::Bucket"
            ]
    }

  depends_on = ["aws_config_configuration_recorder.aws_config_recorder"]
}

resource "aws_config_config_rule" "require_root_account_MFA_enabled" {
  count = "${var.enable_aws_config}" 
  name = "require_root_account_mfa_enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.aws_config_recorder"]
}

resource "aws_config_config_rule" "cloud_trail_enabled" {
  count = "${var.enable_aws_config}" 
  name = "cloud_trail_enabled"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.aws_config_recorder"]
}