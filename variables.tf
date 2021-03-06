variable "resource_group" {
  description = "The name of the resource group in which to create the virtual network."
  default     = "rglb1"
}

variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "rg"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
  default     = "vm"
}

variable "dns_name" {
  description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = "leno"
}

variable "lb_ip_dns_name" {
  description = "DNS for Load Balancer IP"
  default     = "lb01"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "canadaeast"
}

variable "virtual_network_name" {
  description = "The name for the virtual network."
  default     = "vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_DS1_v2"
}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "OpenLogic"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "CentOS"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "7.4"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "adminuser" {
  description = "administrator user name"
  default     = "venerari"
}

variable "sshkey" {
  default     = ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbFiwnxFj92Ma4ce5XKlfpWY/y/FMAOOwtTyGDX8jtyUXiPMYDaKixFqxMZTizFpihafh48RMwDlfT9NWxthvKrv+4uDcPXJhgi1Jwxe7kg/0dk8FbVwxxpY9GLAj5ctqlQ09rkrtymdXx4XxoB5ZlCmwWnRCV5gdJlPUYzepWo0b5Vqf6vAfO2NeCIXt886f8J9aAczhu7WyXnKmvUSOhzJwTyLLjtNXA9BYjNSggcKq381FmdNSi1xP/OTODanB8SIqC6COX8il0ia4U6QNeztJGbN0XMdkHw5uRF3AiABNwdiYJy9wmc8oa9LV2dQ9HsB1KtdjmmvTdnQkj27b9"
}


variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}
