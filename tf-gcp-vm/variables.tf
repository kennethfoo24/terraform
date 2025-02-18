variable "region" {
    description = "The Project ID you wish to deploy into"
}
variable "zone" {
    description = "The zone within a region to use" 
}
variable "location" {
    description = "Zone removed use location instead error"
}
variable "project_id" {
    description = "The Project to launch into"
}
variable "network_name" {
  description = "Creates name for Network and Cluster"
}
variable "name" {
    description = "Setting a name for resources to use"
}

variable "ssh_source_ip" {
  type        = string
  description = "CIDR range allowed to SSH into the VM (e.g., x.x.x.x/32 for your public IP)"
  default     = "0.0.0.0/0"  # <-- You can override this in terraform.tfvars or via -var on CLI
}

variable "vm_name" {
  type        = string
  description = "VM name"
  default     = "kenneth-ubuntu-vm"
}

variable "os_type" {
  type        = string
  description = <<EOT
Select which OS to use. Valid options (in this example):
  - "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
  - "projects/centos-cloud/global/images/family/centos-9"
  - "projects/rhel-cloud/global/images/family/rhel-9"
  - "projects/windows-cloud/global/images/family/windows-2022"
EOT
  default = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
}

