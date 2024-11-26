resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = "v1.30.1"
  name               = var.oke_cluster_name
  type               = "ENHANCED_CLUSTER"
  vcn_id             = oci_core_vcn.oke_vcn.id

  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            =  oci_core_subnet.oke_api_endpoint_subnet.id
  }

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
    service_lb_subnet_ids = [oci_core_subnet.oke_lb_subnet.id]
  }
}

resource "oci_containerengine_node_pool" "k8s_node_pool" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = "v1.30.1"
  name               = var.pool_name
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0].name
      subnet_id           = oci_core_subnet.oke_nodepool_subnet.id
    }

    size = var.node_count

    node_pool_pod_network_option_details {
        cni_type = "OCI_VCN_IP_NATIVE"
        pod_subnet_ids = [oci_core_subnet.oke_nodepool_subnet.id]
    }    
  }
  
  node_shape = "VM.Standard.A1.Flex"

  node_shape_config {
    memory_in_gbs = var.node_memory
    ocpus         = var.node_ocpus
  }

  node_source_details {
    image_id    = "ocid1.image.oc1.sa-vinhedo-1.aaaaaaaadde2g47cav7lpxtitpte3lcvhie5kt2lvdocon3iw3cjsgjbebka" #Vinhedo
    # image_id = "ocid1.image.oc1.phx.aaaaaaaa5celqitaplckhgfnxois4fnxohzkgy4igrfsd5rtkwu4qkyhkzia" #Phoenix
    # image_id = "ocid1.image.oc1.us-chicago-1.aaaaaaaaqj7qal5n7dd5jjsydx4k5rmprfqxmtpvib26qmb3dvi3waixpraa" #Chicago
    source_type = "image"
  }

  initial_node_labels {
    key   = "name"
    value = "OKE"
  }

  # ssh_public_key = var.ssh_public_key
}
