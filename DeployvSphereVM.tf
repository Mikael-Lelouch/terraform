data "vsphere_network" "terraform_switch1" {
    name = "${nsxt_logical_switch.switch1.display_name}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm1" {
    name             = "terraform-test1"
    resource_pool_id = "${data.vsphere_resource_pool.resource_pool}"
    datastore_id     = "${data.vsphere_datastore.datastore.id}"
    num_cpus = 1
    memory   = 1024
    # Attach the VM to the network data source that refers to the newly created logical switch
    network_interface {
      network_id = "${data.vsphere_network.terraform_switch1.id}"
    }
}

#test#Git