# Project Guidelines

* IMPORTANT: Always create a new branch before starting work
* IMPORTANT: Use OpenTofu, not Terraform. The binary is `tofu`.
* IMPORTANT: Do not run `tofu apply` or `tofu destroy`
* IMPORTANT: Always add tags to resources
* IMPORTANT: Use variables instead of hardcoded values
* IMPORTANT: Never delete resources that might be used elsewhere
* IMPORTANT: Add lifecycle blocks to stateful resources
* IMPORTANT: Run `tofu validate` before proposing changes
* IMPORTANT: Use consistent naming conventions
* IMPORTANT: Don't skip pre-commit hooks
* IMPORTANT: Always check for cross-repo references before removing security groups or IAM roles
* IMPORTANT: Add descriptions to all variables
* IMPORTANT: Use data sources instead of hardcoding ARNs
