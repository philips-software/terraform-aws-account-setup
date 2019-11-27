# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [2.0.0] - 27-11-2019
- Upgrade to terraform 0.12, Migration directions:
    - Ensure you are on account setup 1.4.0.
    - Ensure you update Terraform to 0.12.
    - Ensure you providers are update to Terraform 0.12 compatible version.
    - Migrate your code via `terraform 0.12 upgrade`.

## 1.4.0 - 2019-01-03
- Added user for monitoring purposes. See examples/monitor-readonly-user

## 1.3.0 - 2018-12-31
- Added: Cloudtrail with optional s3 bucket #10 by JoostSaanen

## 1.2.0 - 2018-11-22
- Added event selector for cloudtrail, see examples/cloudtrail-with-data-events

## 1.1.2 - 2018-08-21
- FIX: Typo add CI checks to avoid typo's

## 1.1.1 - 2018-08-21
- FIX: Add permission so users without MFA setup can change their password.

## 1.1.0 - 2018-08-08
### Added
- Add the option to enable cloud trail.

## 1.0.0 - 2018-06-27
https://github.com/philips-software/terraform-aws-account-setup/tags/1.0.0

[Unreleased]: https://github.com/philips-software/terraform-aws-account-setup/compare/2.0.0...HEAD
[2.0.0]: https://github.com/philips-software/terraform-aws-account-setup/compare/1.4.0...2.0.0
[1.4.0]: https://github.com/philips-software/terraform-aws-account-setup/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/philips-software/terraform-aws-account-setup/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/philips-software/terraform-aws-account-setup/compare/1.1.2...1.2.0
[1.1.2]: https://github.com/philips-software/terraform-aws-account-setup/compare/1.1.1...1.1.2
[1.1.1]: https://github.com/philips-software/terraform-aws-account-setup/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/philips-software/terraform-aws-account-setup/compare/1.0.0...1.1.0
