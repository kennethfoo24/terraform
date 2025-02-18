variable "region" {
    description = "The Project ID you wish to deploy into"
}
variable "zone" {
    description = "The zone within a region to use" 
}
variable "location" {
    description = "Zone removed use location instead error"
}
variable "project_id" {
    description = "The Project to launch into"
}
variable "network_name" {
  description = "Creates name for Network and Cluster"
}
variable "name" {
    description = "Setting a name for resources to use"
}
variable "subnet_cidr1" {
    description = "This will create a cidr range that you can define in the tf vars file"
}
variable "subnet_cidr2" {
    description = "This will create an additional cidr range that you can define in the tf vars file"
}
