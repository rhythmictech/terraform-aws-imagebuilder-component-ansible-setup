variable "additional_packages" {
  default     = ""
  description = "Space separated list of additional yum packages that may be needed for your ansible workflow"
  type        = string
}

variable "additional_pip_packages" {
  default     = ""
  description = "Space separated list of additional pip packages that may be needed for your ansible workflow"
  type        = string
}

variable "ansible_use_venv" {
  default     = true
  description = "Whether or not ansible should be run in a virtual environment"
  type        = bool
}

variable "ansible_venv_path" {
  default     = "/var/tmp/ansible_venv/"
  description = "Path at which to create the ansible virtual environment"
  type        = string
}

variable "change_description" {
  default     = null
  description = "description of changes since last version"
  type        = string
}

variable "component_version" {
  description = "Version of the component"
  type        = string
}

variable "data_uri" {
  default     = null
  description = "Use this to override the component document with one at a particualar URL endpoint"
  type        = string
}

variable "description" {
  default     = null
  description = "description of component"
  type        = string
}

variable "kms_key_id" {
  default     = null
  description = "KMS key to use for encryption"
  type        = string
}

variable "name" {
  description = "name to use for component"
  type        = string
}

# TODO: #2 add validation
variable "platform" {
  default     = "Linux"
  description = "platform of component (Linux or Windows)"
  type        = string
}

variable "ssh_key_secret_arn" {
  default     = null
  description = "ARN of a secretsmanager secret containing an SSH key (use arn OR name, not both)"
  type        = string
}

variable "ssh_key_secret_name" {
  default     = null
  description = "Name of a secretsmanager secret containing an SSH key (use arn OR name, not both)"
  type        = string
}

variable "supported_os_versions" {
  default     = null
  description = "A set of operating system versions supported by the component. If the OS information is available, a prefix match is performed against the base image OS version during image recipe creation."
  type        = set(string)
}

variable "tags" {
  default     = {}
  description = "map of tags to use for CFN stack and component"
  type        = map(string)
}
