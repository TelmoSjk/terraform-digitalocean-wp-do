variable "region" {
  type        = string
  default     = "nyc1"
  description = "Regiao de uso na Digital Ocean"
}

variable "wp_vm_count" {
  type = number
  default = 2
  description = "Quantidade de VMs para manter HA"

  validation {
    condition = var.wp_vm_count > 1
    error_message = "O numero mínimo de máquinas deve ser 2"
  }
}

variable "vms_ssh" {
  type = string
  description = "Chave ssh das VMs"
}
