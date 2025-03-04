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



