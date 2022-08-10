resource "nsxt_logical_switch" "switch1" {
    admin_state = "UP"
    description = "LS created by Terraform"
    display_name = "${var.nsx_switch_name}"
    transport_zone_id = "${data.nsxt_transport_zone.overlay_tz.id}"
    replication_mode = "MTEP"
    tag {
	scope = "${var.nsx_tag_scope}"
	tag = "${var.nsx_tag}"
    }
    tag {
	scope = "tenant"
	tag = "second_example_tag"
    }
}