# 3-Tier Web Application Deployment on AWS using Terraform and Ansible

> This repository contains a complete Infrastructure-as-Code (IaC) solution for deploying a scalable 3-tier web application on Amazon Web Services (AWS). The infrastructure is provisioned using Terraform, and the servers are configured automatically with Ansible.

This project demonstrates a foundational and secure cloud architecture, separating the application into Web, Application, and Database tiers for enhanced security and management.

---

### Table of Contents
- [Architecture Diagram](#architecture-diagram)
- [How the System Works](#how-the-system-works)
- [Security Features](#security-features)
- [Prerequisites](#prerequisites)
- [Deployment Steps](#deployment-steps)
- [Demonstration](#demonstration)

---

### Architecture Diagram

The architecture is designed with security as a priority. Only the Web Tier is exposed to public traffic, while the Application and Database tiers are isolated in private subnets.

![Architecture Diagram of the 3-Tier Application](https://i.imgur.com/L7E1V3O.png)

---

### How the System Works

The application follows a classic request flow through the different layers:

1.  **User Request**: A user accesses the application by navigating to the public IP address of the Web Tier server in their browser.
2.  **Web Tier (Public Subnet)**:
    * An Nginx server receives the HTTP request and serves the static `index.html` registration form.
    * When the user submits the form, the Web Tier Nginx acts as a **reverse proxy**, forwarding the `submit.php` request to the private IP address of the Application Tier server.
3.  **Application Tier (Private Subnet)**:
    * An Nginx server receives the forwarded request from the Web Tier and passes it to the PHP-FPM service for processing.
    * The `submit.php` script handles the application logic, connects to the database, and inserts the new user information.
4.  **Database Tier (Private Subnet)**:
    * The RDS MySQL instance receives the database connection exclusively from the Application Tier. This is strictly enforced by AWS Security Groups.
    * The user data is then securely stored in the database.

---

### Security Features

Security is a core component of this architecture, implemented through several AWS services:

* **Network Isolation**: The Application and Database Tiers are located in private subnets, making them inaccessible from the public internet. Only the Web Tier is publicly accessible.
* **Firewall Control**: AWS Security Groups act as stateful firewalls, enforcing strict rules on what traffic is allowed between the tiers.
* **Controlled Outbound Access**: A NAT Gateway allows instances in the private subnets (like the App Tier) to access the internet for essential tasks like software updates, without exposing them to inbound connections.

---

### Prerequisites

To deploy this infrastructure, you will need the following installed and configured:

* An AWS Account with appropriate permissions.
* AWS CLI installed and configured (`aws configure`).
* Terraform installed.
* Ansible installed.
* An SSH key pair generated in your target AWS region.

---

### Deployment Steps

Follow these instructions to provision the infrastructure and configure the application.

1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/VIJAY-989060/3-tier-Terraform-ansible.git](https://github.com/VIJAY-989060/3-tier-Terraform-ansible.git)
    cd 3-tier-Terraform-ansible
    ```

2.  **Configure Terraform Variables**
    You need to provide your specific AWS details to Terraform.
    * Navigate to the `terraform/` directory.
    * Rename the example variables file: `mv terraform.tfvars.example terraform.tfvars`.
    * Edit `terraform.tfvars` with your AWS region, the name of your EC2 key pair, and desired database credentials.

3.  **Deploy AWS Infrastructure with Terraform**
    From the `terraform/` directory, run the following commands.
    * Initialize Terraform to download the necessary providers.
        ```bash
        terraform init
        ```
    * Apply the configuration to create the resources. Terraform will show you a plan and ask for confirmation.
        ```bash
        terraform apply
        ```
    * Review the plan and type `yes` to proceed. This process will build all AWS resources and automatically generate the `ansible/inventory.ini` file.

4.  **Configure Servers with Ansible**
    Once the infrastructure is running, navigate to the `ansible/` directory and use the playbooks to install and configure the software.
    ```bash
    ansible-playbook web_setup.yml
    ansible-playbook app_setup.yml
    ansible-playbook db_setup.yml
    ```

5.  **Verify the Deployment**
    Open a web browser and navigate to the `web_server_public_ip` provided in the Terraform output to see the running application. The registration form should be visible and functional.

---

### Demonstration

Here are screenshots demonstrating the successfully deployed and functional application.

**The Registration Form:**
![The Registration Form](https://i.imgur.com/k91B6sL.png)

**Successful Submission Message:**
![Successful Submission Message](https://i.imgur.com/8QdY6tB.png)
