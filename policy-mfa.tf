data "aws_iam_policy_document" "force_mfa" {
  statement {
    sid       = "AllowAllUsersToListAccounts"
    resources = ["*"]

    actions = [
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary"
    ]
  }

  statement {
    sid       = "AllowIndividualUserToSeeAndManageOnlyTheirOwnAccountInformation"
    resources = ["arn:aws:iam::*:user/$${aws:username}"]

    actions = [
      "iam:ChangePassword",
      "iam:CreateAccessKey",
      "iam:CreateLoginProfile",
      "iam:DeleteAccessKey",
      "iam:DeleteLoginProfile",
      "iam:GetLoginProfile",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
      "iam:UpdateLoginProfile",
      "iam:ListSigningCertificates",
      "iam:DeleteSigningCertificate",
      "iam:UpdateSigningCertificate",
      "iam:UploadSigningCertificate",
      "iam:ListSSHPublicKeys",
      "iam:GetSSHPublicKey",
      "iam:DeleteSSHPublicKey",
      "iam:UpdateSSHPublicKey",
      "iam:UploadSSHPublicKey"
    ]
  }

  statement {
    sid = "AllowIndividualUserToListOnlyTheirOwnMFA"

    actions = [
      "iam:ListVirtualMFADevices",
      "iam:ListMFADevices"
    ]

    resources = [
      "arn:aws:iam::*:mfa/*",
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid = "AllowIndividualUserToManageTheirOwnMFA"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice"
    ]

    resources = [
      "arn:aws:iam::*:mfa/$${aws:username}",
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid     = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"
    actions = ["iam:DeactivateMFADevice"]

    resources = [
      "arn:aws:iam::*:mfa/$${aws:username}",
      "arn:aws:iam::*:user/$${aws:username}"
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    sid       = "BlockMostAccessUnlessSignedInWithMFA"
    effect    = "Deny"
    resources = ["*"]

    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:ListVirtualMFADevices",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ListSSHPublicKeys",
      "iam:ListAccessKeys",
      "iam:ListServiceSpecificCredentials",
      "iam:ListMFADevices",
      "iam:GetAccountSummary",
      "iam:ChangePassword",
      "sts:GetSessionToken"
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_policy" "mfa" {
  count = var.enable_mfa ? 1 : 0

  name        = "ForceMFA"
  path        = "/"
  description = "Policy to enforce MFA"

  policy = data.aws_iam_policy_document.force_mfa.json
}

