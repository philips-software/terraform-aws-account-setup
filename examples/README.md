# Examples
Examples for this modules.

### Prerequisites for running the example
Terraform is managed via the tool `tfenv`. Ensure you have installed [tfenv](https://github.com/kamatama41/tfenv). And install via tfenv the required terraform version as listed in `.terraform-version`

## cloudtrail
Example shows the usages of the cloudtrail feature.

## default
Example shows the default usages of the module. The module creates the following items:
- An admin group
- MFA policy attachted to the admin group
- Sets pssword policies.

## read only group
Example shows the usages of the read only group feature

## mfa only
Example shows how to use the module for creating only the MFA policies.

## strict password
Example shows how to use the module to configure only the password rules.
