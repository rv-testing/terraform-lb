
resource "azurerm_resource_group" "test" {
 name     = "acctestrg3"
 location = "Canada East"
}

resource "azurerm_virtual_network" "test" {
 name                = "acctvn"
 address_space       = ["10.0.0.0/16"]
 location            = "${azurerm_resource_group.test.location}"
 resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "test" {
 name                 = "acctsub"
 resource_group_name  = "${azurerm_resource_group.test.name}"
 virtual_network_name = "${azurerm_virtual_network.test.name}"
 address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "test" {
 name                         = "publicIPForLB"
 location                     = "${azurerm_resource_group.test.location}"
 resource_group_name          = "${azurerm_resource_group.test.name}"
 public_ip_address_allocation = "static"
}

resource "azurerm_lb" "test" {
 name                = "loadBalancer"
 location            = "${azurerm_resource_group.test.location}"
 resource_group_name = "${azurerm_resource_group.test.name}"

 frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id = "${azurerm_public_ip.test.id}"
 }
}

resource "azurerm_lb_rule" "test" {
  resource_group_name            = "${azurerm_resource_group.test.name}"
  loadbalancer_id                = "${azurerm_lb.test.id}"
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_backend_address_pool" "test" {
 resource_group_name = "${azurerm_resource_group.test.name}"
 loadbalancer_id     = "${azurerm_lb.test.id}"
 name                = "BackEndAddressPool"
}

resource "azurerm_network_interface" "test" {
 count               = 2
 name                = "acctni${count.index}"
 location            = "${azurerm_resource_group.test.location}"
 resource_group_name = "${azurerm_resource_group.test.name}"

 ip_configuration {
   name                          = "testConfiguration"
   subnet_id                     = "${azurerm_subnet.test.id}"
   private_ip_address_allocation = "dynamic"
   load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.test.id}"]
 }
}

resource "azurerm_managed_disk" "test" {
 count                = 2
 name                 = "datadisk_existing_${count.index}"
 location             = "${azurerm_resource_group.test.location}"
 resource_group_name  = "${azurerm_resource_group.test.name}"
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "100"
}

resource "azurerm_availability_set" "avset" {
 name                         = "avset"
 location                     = "${azurerm_resource_group.test.location}"
 resource_group_name          = "${azurerm_resource_group.test.name}"
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
}

resource "azurerm_virtual_machine" "test" {
 count                 = 2
 name                  = "acctvm${count.index}"
 location              = "${azurerm_resource_group.test.location}"
 availability_set_id   = "${azurerm_availability_set.avset.id}"
 resource_group_name   = "${azurerm_resource_group.test.name}"
 network_interface_ids = ["${element(azurerm_network_interface.test.*.id, count.index)}"]
 vm_size               = "Standard_D1_V2"
 delete_os_disk_on_termination = true
 delete_data_disks_on_termination = true

 storage_image_reference {
   publisher = "OpenLogic"
   offer     = "CentOS"
   sku       = "7.4"
   version   = "latest"
 }

 storage_os_disk {
   name              = "myosdisk${count.index}"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 # Optional data disks
 storage_data_disk {
   name              = "datadisk_new_${count.index}"
   managed_disk_type = "Standard_LRS"
   create_option     = "Empty"
   lun               = 0
   disk_size_gb      = "100"
 }

 storage_data_disk {
   name            = "${element(azurerm_managed_disk.test.*.name, count.index)}"
   managed_disk_id = "${element(azurerm_managed_disk.test.*.id, count.index)}"
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = "${element(azurerm_managed_disk.test.*.disk_size_gb, count.index)}"
 }

 os_profile {
   computer_name  = "hostname"
   admin_username = "${var.admin_user}"
 }

 os_profile_linux_config {
   disable_password_authentication = true
    ssh_keys {
            path     = "/home/venerari/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbFiwnxFj92Ma4ce5XKlfpWY/y/FMAOOwtTyGDX8jtyUXiPMYDaKixFqxMZTizFpihafh48RMwDlfT9NWxthvKrv+4uDcPXJhgi1Jwxe7kg/0dk8FbVwxxpY9GLAj5ctqlQ09rkrtymdXx4XxoB5ZlCmwWnRCV5gdJlPUYzepWo0b5Vqf6vAfO2NeCIXt886f8J9aAczhu7WyXnKmvUSOhzJwTyLLjtNXA9BYjNSggcKq381FmdNSi1xP/OTODanB8SIqC6COX8il0ia4U6QNeztJGbN0XMdkHw5uRF3AiABNwdiYJy9wmc8oa9LV2dQ9HsB1KtdjmmvTdnQkj27b9 itikabc@centos"
        }
 }

 tags {
   environment = "staging"
 }
}
