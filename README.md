# IaC Homework - Terraform Cloud + AWS

## Project Description

This project was created as part of an Infrastructure as Code homework.

The goal is to use **Terraform Cloud** and **Infrastructure as Code (IaC)** to deploy a virtual machine that exposes a simple web server with an HTML page displaying:

```text
Hi, I am Luis Crispim and this is my IaC
```

The infrastructure is deployed in **AWS** using Terraform and is managed through **Terraform Cloud**.

---

## Cloud Provider

The selected cloud provider for this implementation is:

```text
AWS
```

AWS was used to create the required networking and compute resources needed to expose a public web page.

---

## Tools Used

- Terraform
- Terraform Cloud / HCP Terraform
- AWS
- GitHub
- Visual Studio Code

---

## Architecture Overview

The solution deploys a simple public web server using the following AWS resources:

- VPC
- Public Subnet
- Internet Gateway
- Public Route Table
- Route Table Association
- Security Group
- EC2 Instance
- Apache Web Server installed through EC2 user data

The EC2 instance is deployed inside a public subnet and exposed to the internet through HTTP port 80.

---

## Infrastructure Diagram

```text
Internet
   |
   v
Internet Gateway
   |
   v
Public Route Table
   |
   v
Public Subnet
   |
   v
Security Group - HTTP 80
   |
   v
EC2 Instance running Apache
   |
   v
HTML Web Page
```

---

## Repository Structure

```text
iac-homework-terraform/
├── versions.tf
├── provider.tf
├── main.tf
├── variables.tf
├── locals.tf
├── outputs.tf
├── terraform.tfvars.example
├── .gitignore
├── README.md
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── compute/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── user_data.sh
```

---

## Terraform Cloud

This project uses Terraform Cloud as the remote execution environment.

Terraform Cloud is responsible for:

- Running Terraform plans
- Running Terraform applies
- Storing the remote Terraform state
- Managing workspace variables
- Keeping the infrastructure execution history

The workspace is connected to this GitHub repository using the Version Control workflow.

---

## Terraform Modules

The project is divided into modules to follow Infrastructure as Code best practices.

### Network Module

Location:

```text
modules/network
```

This module creates the networking resources:

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route to the Internet Gateway
- Route Table Association

### Compute Module

Location:

```text
modules/compute
```

This module creates the compute resources:

- Security Group
- EC2 Instance
- Apache web server using user data
- Static HTML page

---

## Dynamic Variables

The project uses variables to make the infrastructure reusable and easy to replicate.

Main variables:

```hcl
aws_region   = "us-east-1"
project_name = "iac-homework-terraform"
environment  = "dev"
owner        = "Luis Crispim"
```

These variables are used to dynamically define resource names, tags and configuration values.

For example, resource names are generated using:

```hcl
local.name_prefix = "${var.project_name}-${var.environment}"
```

This produces names like:

```text
iac-homework-terraform-dev-vpc
iac-homework-terraform-dev-public-subnet
iac-homework-terraform-dev-web-server
```

Changing the `project_name` or `environment` variable allows the infrastructure to be replicated without overwriting the previous deployment.

---

## Dynamic Tags

The project also uses common tags for all AWS resources.

Example:

```hcl
common_tags = {
  Project     = var.project_name
  Environment = var.environment
  Owner       = var.owner
  ManagedBy   = "Terraform"
  Purpose     = "IaC Homework"
}
```

These tags help identify who owns the resources, what project they belong to and how they are managed.

---

## Idempotency

This project is idempotent because Terraform manages the desired state of the infrastructure using Terraform Cloud remote state.

When the infrastructure is applied for the first time, Terraform creates the required AWS resources.

If the same configuration is executed again without changes, Terraform compares the desired state defined in the code with the current state stored in Terraform Cloud and does not create duplicated resources.

During the implementation, an initial apply created the networking resources successfully but failed when creating the EC2 instance because the selected instance type was not eligible. After changing the instance type, Terraform planned only the missing EC2 instance and did not recreate the VPC, subnet, route table, internet gateway or security group.

This demonstrates Terraform's idempotent behavior.

---

## Page Exposure Steps

The web page is exposed to the internet using the following steps:

1. A VPC is created to isolate the network.
2. A public subnet is created with public IP assignment enabled.
3. An Internet Gateway is attached to the VPC.
4. A public route table is configured with a route to `0.0.0.0/0` through the Internet Gateway.
5. The public subnet is associated with the public route table.
6. A Security Group allows inbound HTTP traffic on port 80.
7. An EC2 instance is deployed inside the public subnet.
8. The EC2 instance receives a public IP address.
9. Apache is installed using the EC2 user data script.
10. The HTML page is created in `/var/www/html/index.html`.

---

## Web Server

The EC2 instance installs Apache using the following user data script:

```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>IaC Homework</title>
</head>
<body>
  <h1>Hi, I am ${owner} and this is my IaC</h1>
</body>
</html>
EOF
```

The page displays the required message using the `owner` variable.

---

## Terraform Cloud Variables

The following variables are configured in Terraform Cloud.

### Environment Variables

These variables are marked as sensitive:

| Key | Category | Sensitive |
|---|---|---|
| `AWS_ACCESS_KEY_ID` | Environment variable | Yes |
| `AWS_SECRET_ACCESS_KEY` | Environment variable | Yes |

### Terraform Variables

These variables are not sensitive:

| Key | Value | Category | Sensitive |
|---|---|---|---|
| `aws_region` | `us-east-1` | Terraform variable | No |
| `project_name` | `iac-homework-terraform` | Terraform variable | No |
| `environment` | `dev` | Terraform variable | No |
| `owner` | `Luis Crispim` | Terraform variable | No |

---

## Outputs

The project exposes the following Terraform outputs:

```hcl
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.compute.instance_public_ip
}

output "website_url" {
  description = "URL to access the web server"
  value       = "http://${module.compute.instance_public_ip}"
}
```

The `website_url` output is used to access the exposed web page.

---

## How to Deploy

1. Push the Terraform code to GitHub.
2. Connect the GitHub repository to Terraform Cloud.
3. Configure the required Terraform Cloud variables.
4. Start a new Terraform plan.
5. Review the resources that Terraform will create.
6. Confirm and apply the plan.
7. Wait for the apply to finish.
8. Open the `website_url` output in a browser.

---

## Expected Terraform Plan

The expected Terraform plan should create resources similar to:

```text
aws_vpc
aws_subnet
aws_internet_gateway
aws_route_table
aws_route
aws_route_table_association
aws_security_group
aws_instance
```

The expected result is:

```text
8 to add, 0 to change, 0 to destroy
```

No NAT Gateway, Load Balancer, database, Kubernetes cluster or Elastic IP is required for this homework.

---

## How to Validate

After the Terraform apply finishes successfully:

1. Go to the Terraform Cloud workspace.
2. Open the latest successful run.
3. Review the outputs.
4. Copy the `website_url`.
5. Open the URL in a browser.
6. Confirm that the page displays:

```text
Hi, I am Luis Crispim and this is my IaC
```

---

## Validation Note

The website was successfully validated using the public IP generated by Terraform Cloud outputs.

Access from a corporate network may be blocked by web filtering policies because the endpoint is an uncategorized public IP. The endpoint was successfully tested from a non-corporate mobile network.

---

## Cost Control

This project was designed to use only minimal AWS resources.

The project intentionally does not create:

- NAT Gateway
- Load Balancer
- Elastic IP
- RDS database
- EKS cluster
- ECS/Fargate services
- Multi-AZ infrastructure

Only one small EC2 instance and the minimum required networking resources are created.

To avoid unexpected costs, the infrastructure should be destroyed after evaluation.

---

## How to Destroy

After the homework is reviewed, the infrastructure can be destroyed from Terraform Cloud.

Steps:

1. Go to the Terraform Cloud workspace.
2. Create a destroy plan.
3. Review the resources that will be destroyed.
4. Confirm and apply the destroy plan.

This removes the AWS resources created by Terraform.

---

## Results to Share

The final delivery should include:

- GitHub repository link
- Terraform Cloud workspace access
- Public IP or website endpoint
- Screenshots or evidence of the deployment
- Screenshot of the web page working

---

## Evidence

Evidence screenshots can be stored in:

```text
docs/evidence/
```

Recommended screenshots:

```text
01-terraform-cloud-apply-success.png
02-terraform-cloud-outputs.png
03-website-running.png
04-aws-ec2-instance.png
05-aws-vpc-resources.png
06-github-repository.png
```

---

## Final Website Message

```text
Hi, I am Luis Crispim and this is my IaC
```