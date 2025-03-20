terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0" # or the latest stable
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  
  # If you're using Application Default Credentials (ADC),
  # Terraform will pick them up automatically.
  #
  # Or if you want to specify a service account key:
  # credentials = file("path/to/service-account.json")
}

# 1) Create a custom VPC network (no auto subnet creation)
resource "google_compute_network" "default" {
  name                    = var.network_name
  project                 = var.project_id
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

# 2) Create a subnetwork within that VPC
resource "google_compute_subnetwork" "default" {
  name          = var.network_name
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.default.self_link
  ip_cidr_range = "10.0.0.0/24"
}

# 3) Create a firewall rule to allow SSH (port 22) into the network (optional but often needed)
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-in-custom-vpc"
  project = var.project_id
  network = google_compute_network.default.self_link

  # Allow SSH (22) and RDP (3389)
  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  # Adjust the CIDR range as needed (here allowing SSH from anywhere).
  source_ranges = [var.ssh_source_ip]
}

# 4) Create an Ubuntu VM attached to the custom VPC/subnet
resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = "e2-medium"
  zone         = var.zone

  # Boot disk with an Ubuntu image
  boot_disk {
    initialize_params {
      image = var.os_type
      size  = 128
      type  = "pd-ssd"
    }
  }

  # Attach to the custom VPC and subnetwork
  network_interface {
    network    = google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.default.self_link
    # Gives the VM a public IP. Comment this out if you only want private IPs.
    access_config {}
  }
}

# Terraform will output this data once everything has been created
output "network" {
  value = google_compute_subnetwork.default.network
}

output "subnetwork_name" {
  value = google_compute_subnetwork.default.name
}

output "vm_name" {
  description = "Name of the newly created VM"
  value       = google_compute_instance.vm.name
}

output "zone" {
  description = "Zone of the newly created VM"
  value       = google_compute_instance.vm.zone
}

output "boot_disk_image" {
  description = "Image used for the VM's boot disk"
  value       = google_compute_instance.vm.boot_disk[0].initialize_params[0].image
}
