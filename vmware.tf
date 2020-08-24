provider "vsphere" {
  user           = "*protected email*"
  password       = "VMware1!"
  vsphere_server = "192.168.30.200"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Primp-Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "sm-vsanDatastore"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = "Supermicro-Cluster/Resources/Workload"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "192.168.30.14"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vmFromRemoteOvf" {
  name = "Nested-ESXi-7.0-Terraform-Deploy-1"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id = data.vsphere_datastore.datastore.id
  datacenter_id = data.vsphere_datacenter.datacenter.id
  host_system_id = data.vsphere_host.host.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0

  ovf_deploy {
    remote_ovf_url = "https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0_Appliance_Template_v1.ova"
    disk_provisioning = "thin"
    ovf_network_map = {
        "VM Network" = data.vsphere_network.network.id
    }
  }

  vapp {
    properties = {
      "guestinfo.hostname" = "tf-nested-esxi-1.primp-industries.com",
      "guestinfo.ipaddress" = "192.168.30.180",
      "guestinfo.netmask" = "255.255.255.0",
      "guestinfo.gateway" = "192.168.30.1",
      "guestinfo.dns" = "192.168.30.1",
      "guestinfo.domain" = "primp-industries.com",
      "guestinfo.ntp" = "pool.ntp.org",
      "guestinfo.password" = "VMware1!23",
      "guestinfo.ssh" = "True"
    }
  }
}

resource "vsphere_virtual_machine" "vmFromLocalOvf" {
  name = "Nested-ESXi-7.0-Terraform-Deploy-2"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id = data.vsphere_datastore.datastore.id
  datacenter_id = data.vsphere_datacenter.datacenter.id
  host_system_id = data.vsphere_host.host.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0

  ovf_deploy {
    local_ovf_path = "/Volumes/Storage/Software/Nested_ESXi7.0_Appliance_Template_v1.ova"
    disk_provisioning = "thin"
    ovf_network_map = {
        "VM Network" = data.vsphere_network.network.id
    }
  }

  vapp {
    properties = {
      "guestinfo.hostname" = "tf-nested-esxi-2.primp-industries.com",
      "guestinfo.ipaddress" = "192.168.30.181",
      "guestinfo.netmask" = "255.255.255.0",
      "guestinfo.gateway" = "192.168.30.1",
      "guestinfo.dns" = "192.168.30.1",
      "guestinfo.domain" = "primp-industries.com",
      "guestinfo.ntp" = "pool.ntp.org",
      "guestinfo.password" = "VMware1!23",
      "guestinfo.ssh" = "True"
    }
  }
}
