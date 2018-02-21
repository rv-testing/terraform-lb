output "hostname" {
  value = "${var.hostname}"
}

output "vm_fqdn" {
  value = "${azurerm_public_ip.lbpip.fqdn}"
}

output "ssh_command" {
  value = "ssh ${var.adminuser}@${azurerm_public_ip.lbpip.fqdn}"
}
