## Cloudtrail with data events
Example shows the usages of the cloudtrail feature with added data events

- cloudtrail enabled
- all defaults enabled
- Added logging for s3 read events on all buckets and api invocations on all lambdas [terraform cloudtrail event-selector docs](https://www.terraform.io/docs/providers/aws/r/cloudtrail.html#event-selector-arguments)

## Prerequisites for running the example
Terraform is managed via the tool `tfenv`. Ensure you have installed [tfenv](https://github.com/kamatama41/tfenv). And install via tfenv the required terraform version as listed in `.terraform-version`
