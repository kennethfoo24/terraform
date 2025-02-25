## Terraform

## Deployment

1. Create GCP project

2. Open Cloud Shell
![Logo](https://i.imgur.com/INpj5Kf.png)

3. Clone this git repo and run the initial setup script

```bash
  git clone https://github.com/kennethfoo24/terraform.git
  cd terraform/tf-gcp-vm/
  ./setup.sh
```

NOTE: If you’d like to modify the default input variables, feel free to modify the tfvars in the setup.sh script before executing. The following inputs are provided as defaults:

```bash
~/setup.sh

  region          = "us-central1"
  zone            = "us-central1-c"
  location        = "us-central1-c"
  project_id      = "$GOOGLE_CLOUD_PROJECT"
  name            = "kenneth-ubuntu-vm"
  vm_name         = "kenneth-ubuntu-vm"
  network_name    = "kenneth-vm-network"
  ssh_source_ip   = "${MY_IP}/32"
  os_type         = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts". 

```

4. Authorize Cloud Shell

5. The terraform template main.tf contains the instructions that Google Cloud needs to build out a simple Kubernetes Cluster.  Running terraform plan will list out everything that will be built using the template.  It also acts as a syntax checker for the template.
```bash
  terraform plan
```

6. The terraform apply command will build out the cluster based on what is documented in the main.tf template.  Once the apply is complete you can run the k8sCreds.sh command which will authenticate you to the newly built Kubernetes cluster.  
```bash
  terraform apply --auto-approve
  ./connect.sh
```



## Tear Down

```bash
  terraform destroy
```






    