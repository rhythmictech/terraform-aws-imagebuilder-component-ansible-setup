# terraform-aws-component-ansible-setup
Template repository for terraform modules. Good for any cloud and any provider.

[![tflint](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

Terraform module that creates an EC2 Image Builder component with CloudFormation which installs Ansible on Amazon Linux 2

## Example
```hcl
data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  tags       = module.tags.tags_no_name
}

module "tags" {
  source  = "rhythmictech/tags"
  version = "~> 1.1.0"

  names = [
    "smiller",
    "imagebuilder-test"
  ]

  tags = merge({
    "Env"       = "test"
    "Namespace" = "smiller"
    "notes"     = "Testing only - Can be safely deleted"
    "Owner"     = var.owner
  }, var.additional_tags)
}

module "component_ansible_setup" {
  source  = "rhythmictech/imagebuilder-component-ansible-setup/aws"
  version = "~> 1.0.0-rc1"

  component_version = "1.0.0"
  description       = "Testing ansible setup"
  name              = "testing-setup-component"
  tags              = local.tags
}

module "test_recipe" {
  source  = "rhythmictech/imagebuilder-recipe/aws"
  version = "~> 0.2.0"

  description    = "Testing recipe"
  name           = "test-recipe"
  parent_image   = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"
  recipe_version = "1.0.0"
  tags           = local.tags
  update         = true

  component_arns = [
    module.component_ansible_setup.component_arn,
    "arn:aws:imagebuilder:us-east-1:aws:component/simple-boot-test-linux/1.0.0/1",
    "arn:aws:imagebuilder:us-east-1:aws:component/reboot-test-linux/1.0.0/1"
  ]
}

module "test_pipeline" {
  source  = "rhythmictech/imagebuilder-pipeline/aws"
  version = "~> 0.3.0"

  description = "Testing pipeline"
  name        = "test-pipeline"
  tags        = local.tags
  recipe_arn  = module.test_recipe.recipe_arn
  public      = false
}

```

## About
This module bridges the gap allowing Terraform to create an EC2 Image Builder component which installs Ansible on Amazon Linux 2 until native support for Image Builder is added to Terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.28 |
| aws | >= 2.44, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.44, < 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| component\_version | Version of the component | `string` | n/a | yes |
| name | name to use for component | `string` | n/a | yes |
| additional\_packages | Space separated list of additional packages that may be needed for your ansible workflow | `string` | `""` | no |
| change\_description | description of changes since last version | `string` | `null` | no |
| cloudformation\_timeout | How long to wait (in minutes) for CFN to apply before giving up | `number` | `10` | no |
| data\_uri | Use this to override the component document with one at a particualar URL endpoint | `string` | `null` | no |
| description | description of component | `string` | `null` | no |
| kms\_key\_id | KMS key to use for encryption | `string` | `null` | no |
| platform | platform of component (Linux or Windows) | `string` | `"Linux"` | no |
| ssh\_key\_secret\_arn | ARN of a secretsmanager secret containing an SSH key (use arn OR name, not both) | `string` | `null` | no |
| ssh\_key\_secret\_name | Name of a secretsmanager secret containing an SSH key (use arn OR name, not both) | `string` | `null` | no |
| tags | map of tags to use for CFN stack and component | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| component\_arn | ARN of the EC2 Image Builder Component |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants underneath this module
- pre-commit.com/
- terraform.io/
- github.com/tfutils/tfenv
- github.com/segmentio/terraform-docs
