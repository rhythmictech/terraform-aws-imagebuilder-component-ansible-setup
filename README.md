# terraform-aws-component-ansible-setup
Template repository for terraform modules. Good for any cloud and any provider.

[![tflint](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-component-ansible-setup/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

Terraform module that creates an EC2 Image Builder component which installs Ansible on Amazon Linux 2

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
This module serves as an EC2 Image Builder component to install Ansible on an Amazon Linux 2 image.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.53.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_imagebuilder_component.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_component) | resource |
| [aws_secretsmanager_secret.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_packages"></a> [additional\_packages](#input\_additional\_packages) | Space separated list of additional yum packages that may be needed for your ansible workflow | `string` | `""` | no |
| <a name="input_additional_pip_packages"></a> [additional\_pip\_packages](#input\_additional\_pip\_packages) | Space separated list of additional pip packages that may be needed for your ansible workflow | `string` | `""` | no |
| <a name="input_ansible_use_venv"></a> [ansible\_use\_venv](#input\_ansible\_use\_venv) | Whether or not ansible should be run in a virtual environment | `bool` | `true` | no |
| <a name="input_ansible_venv_path"></a> [ansible\_venv\_path](#input\_ansible\_venv\_path) | Path at which to create the ansible virtual environment | `string` | `"/var/tmp/ansible_venv/"` | no |
| <a name="input_change_description"></a> [change\_description](#input\_change\_description) | description of changes since last version | `string` | `null` | no |
| <a name="input_component_version"></a> [component\_version](#input\_component\_version) | Version of the component | `string` | n/a | yes |
| <a name="input_data_uri"></a> [data\_uri](#input\_data\_uri) | Use this to override the component document with one at a particualar URL endpoint | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | description of component | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key to use for encryption | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | name to use for component | `string` | n/a | yes |
| <a name="input_platform"></a> [platform](#input\_platform) | platform of component (Linux or Windows) | `string` | `"Linux"` | no |
| <a name="input_ssh_key_secret_arn"></a> [ssh\_key\_secret\_arn](#input\_ssh\_key\_secret\_arn) | ARN of a secretsmanager secret containing an SSH key (use arn OR name, not both) | `string` | `null` | no |
| <a name="input_ssh_key_secret_name"></a> [ssh\_key\_secret\_name](#input\_ssh\_key\_secret\_name) | Name of a secretsmanager secret containing an SSH key (use arn OR name, not both) | `string` | `null` | no |
| <a name="input_supported_os_versions"></a> [supported\_os\_versions](#input\_supported\_os\_versions) | A set of operating system versions supported by the component. If the OS information is available, a prefix match is performed against the base image OS version during image recipe creation. | `set(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | map of tags to use for CFN stack and component | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_component_arn"></a> [component\_arn](#output\_component\_arn) | ARN of the EC2 Image Builder Component |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants underneath this module
- pre-commit.com/
- terraform.io/
- github.com/tfutils/tfenv
- github.com/segmentio/terraform-docs
