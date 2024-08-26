# data "oci_containerengine_cluster_option" "oci_oke_cluster_option" {
#   cluster_option_id = "all"
# }

# data "oci_containerengine_node_pool_option" "oci_oke_node_pool_option" {
#   node_pool_option_id = "all"
# }

data "oci_core_services" "AllOCIServices" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}


# data "oci_core_images" "shape_specific_images" {

#   compartment_id = var.tenancy_ocid
#   shape = var.node_shape
# }

# locals {
#   all_images = "${data.oci_core_images.shape_specific_images.images}"
#   all_sources = "${data.oci_containerengine_node_pool_option.oci_oke_node_pool_option.sources}"

#   compartment_images = [for image in local.all_images : image.id if length(regexall("Oracle-Linux-[0-9]*.[0-9]*-20[0-9]*",image.display_name)) > 0 ]

#   oracle_linux_images = [for source in local.all_sources : source.image_id if length(regexall("Oracle-Linux-[0-9]*.[0-9]*-20[0-9]*",source.source_name)) > 0]

#   image_id = tolist(setintersection( toset(local.compartment_images), toset(local.oracle_linux_images)))[0]

# }