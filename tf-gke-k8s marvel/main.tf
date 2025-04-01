# Configure the Google Cloud provider
provider "google" {
  project     = var.project_id
  region      = var.region
}

# Create network based on the network_name variable
resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Create subnet based on the network_name, and region variables
resource "google_compute_subnetwork" "default" {
  name                     = var.network_name
  ip_cidr_range            = "10.128.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

# Create ingress firewall rule
resource "google_compute_firewall" "ingress_allow_ports" {
  name    = "${var.network_name}-ingress-allow"
  network = google_compute_network.default.self_link

  # Ingress rules
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "5432", "8080", "9090", "30000-30099"]
  }

  # Adjust this range or provide specific CIDRs to narrow who can access these ports
  source_ranges = [
    "173.255.113.66",
    "34.45.150.10",
    "34.132.64.186",
    "35.225.88.131",
    var.ssh_source_ip
  ]
}

# Use this data source to access the configuration of the Google Cloud provider 
data "google_client_config" "current" {
}

# Provides access to available Google Kubernetes Engine versions in a zone or region for a given project.
data "google_container_engine_versions" "default" {
  location = var.location
}

# Create cluster with 3 nodes
resource "google_container_cluster" "default" {
  name               = var.network_name
  location           = var.location
  initial_node_count = 3
  min_master_version = data.google_container_engine_versions.default.latest_master_version
  deletion_protection = false
  network            = google_compute_subnetwork.default.name
  subnetwork         = google_compute_subnetwork.default.name

  node_config {
    machine_type = var.node_machine_type
  }

  # Cluster-level resource labels
  resource_labels = {
    please_keep_my_resource = "true" 
    team         = "sales-eng-apj"
    user         = "kenneth_foo"
    securitydelete = "false"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }
}
# Terraform will output this data once everything has been created
output "network" {
  value = google_compute_subnetwork.default.network
}

output "subnetwork_name" {
  value = google_compute_subnetwork.default.name
}

output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_region" {
  value = var.region
}



