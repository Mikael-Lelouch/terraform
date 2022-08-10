terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"    }
    vsphere = {
       source = "vsphere"
    }
  }
}

# configure some variables first

variable "vsphere_user" {
    default = "vra-mika@cpod-cds-partenaire.az-lab.shwrfr.com"
  
}

variable "vsphere_password" {
    default = "6x!Y2lgrt1i2cD^N"
  
}
variable "vsphere_server" {
    default = "vcsa.cpod-cds-partenaire.az-lab.shwrfr.com"
  
}

variable "nsx_ip" {
    default = "172.20.4.10"
}
variable "nsx_password" {
    default = "AzsX%09xsZp!."
}

variable "nsx_tag_scope" {
    default = "project"
}
variable "nsx_tag" {
    default = "terraform-demo"
}
variable "nsx_t1_router_name" {
    default = "terraform-demo-router"
}
variable "nsx_t1_ip" {
    default = "192.168.1.1/24"
}
variable "nsx_switch_name" {
    default = "terraform-demo-ls"
}

# Configure the VMware NSX-T Provider
provider "nsxt" {
    host = "${var.nsx_ip}"
    username = "guestuser1"
    password = "${var.nsx_password}"
    allow_unverified_ssl = true
}

data "nsxt_transport_zone" "overlay_tz" {
    display_name = "nsx-overlay-transportzone"
}
data "nsxt_logical_tier0_router" "tier0_router" {
  display_name = "T0-Global"
}
data "nsxt_edge_cluster" "edge_cluster" {
    display_name = "Edge-Cluster"
}

# Configure the VMware vSPhere Provider
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "cPod-CDS-PARTENAIRE"
}

data "vsphere_datastore" "datastore" {
  name          = "Datastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "resource_pool" {
  name                    = "resource-pool-01"
}