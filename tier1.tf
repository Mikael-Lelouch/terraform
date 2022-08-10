resource "nsxt_logical_tier1_router" "tier1_router" {
  description                 = "RTR1 provisioned by Terraform"
  display_name                = "RTR1"
  failover_mode               = "PREEMPTIVE"
  edge_cluster_id             = data.nsxt_edge_cluster.edge_cluster.id
  enable_router_advertisement = true
  advertise_connected_routes  = false
  advertise_static_routes     = true
  advertise_nat_routes        = true
  advertise_lb_vip_routes     = true
  advertise_lb_snat_ip_routes = false

  tag {
    scope = "color"
    tag   = "blue"
  }
}