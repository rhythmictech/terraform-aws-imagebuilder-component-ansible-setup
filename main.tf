locals {
  has_ssh_key = var.ssh_key_secret_arn != null || var.ssh_key_secret_name != null

  data = templatefile("${path.module}/component.yml.tpl", {
    additional_pkgs     = var.additional_packages
    additional_pip_pkgs = var.additional_pip_packages
    ansible_venv_path   = var.ansible_venv_path
    description         = var.description
    name                = var.name
    ssh_key_name        = try(data.aws_secretsmanager_secret.ssh_key[0].name, null)
    use_venv            = var.ansible_use_venv
  })
}

data "aws_secretsmanager_secret" "ssh_key" {
  count = local.has_ssh_key ? 1 : 0

  arn  = var.ssh_key_secret_arn
  name = var.ssh_key_secret_name
}

resource "aws_imagebuilder_component" "this" {
  name    = var.name
  version = var.component_version

  change_description    = var.change_description
  data                  = var.data_uri == null ? local.data : null
  description           = var.description
  kms_key_id            = var.kms_key_id
  platform              = var.platform
  supported_os_versions = var.supported_os_versions
  uri                   = var.data_uri

  tags = merge(
    var.tags,
    { Name : "${var.name}" }
  )
}
