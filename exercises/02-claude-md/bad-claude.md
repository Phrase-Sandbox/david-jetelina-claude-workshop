# Project Guidelines

* Use OpenTofu, not Terraform
* Do not run `tofu apply` or `tofu destroy`
* Always add tags to resources
* Use variables instead of hardcoded values
* Never delete resources that might be used elsewhere
* Add lifecycle blocks to stateful resources
* Run `tofu validate` before proposing changes
* Use consistent naming conventions
* Don't skip pre-commit hooks
* Always check for cross-repo references before removing security groups or IAM roles
