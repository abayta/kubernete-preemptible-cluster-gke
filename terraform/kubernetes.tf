resource "google_container_cluster" "testing" {
  name      = "first-test-cluster"
  location  = "${var.region}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }

  # Not set node config in the cluster, terraform got confused with that
  # node_config {
  #   oauth_scopes = [
  #     "https://www.googleapis.com/auth/compute",
  #     "https://www.googleapis.com/auth/devstorage.read_only",
  #     "https://www.googleapis.com/auth/logging.write",
  #     "https://www.googleapis.com/auth/monitoring",
  #   ]
  # }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "preemp-pool"
  location   = "${var.region}"
  cluster    = "${google_container_cluster.testing.name}"

  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

  depends_on = ["google_container_cluster.testing"]

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/sqlservice.admin",
      "https://www.googleapis.com/auth/trace.append"

      # "https://www.googleapis.com/auth/compute",
      # "https://www.googleapis.com/auth/devstorage.full_control",
    ]
  }
}

# resource "null_resource" "jenkins" {
  
# }


# # The following outputs allow authentication and connectivity to the GKE Cluster
# # by using certificate-based authentication.
# output "client_certificate" {
#   value = "${google_container_cluster.testing.master_auth.0.client_certificate}"
# }

# output "client_key" {
#   value = "${google_container_cluster.testing.master_auth.0.client_key}"
# }

# output "cluster_ca_certificate" {
#   value = "${google_container_cluster.testing.master_auth.0.cluster_ca_certificate}"
# }
