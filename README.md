# 3-tier-Terraform-ansible
# 3-Tier Web Application Deployment on AWS using Terraform and Ansible

> [cite_start]This repository contains a complete Infrastructure-as-Code (IaC) solution for deploying a scalable 3-tier web application on Amazon Web Services (AWS). [cite: 468] [cite_start]The infrastructure is provisioned using Terraform, and the servers are configured automatically with Ansible. [cite: 469]

[cite_start]This project demonstrates a foundational and secure cloud architecture, separating the application into Web, Application, and Database tiers for enhanced security and management. [cite: 471]

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

The architecture is designed with security as a priority. [cite_start]Only the Web Tier is exposed to public traffic, while the Application and Database tiers are isolated in private subnets. [cite: 471, 480, 481]

![Architecture Diagram of the 3-Tier Application](https://i.imgur.com/L7E1V3O.png)

---

### How the System Works

The application follows a classic request flow through the different layers:

1.  [cite_start]**User Request**: A user accesses the application by navigating to the public IP address of the Web Tier server in their browser. [cite: 473]
2.  **Web Tier (Public Subnet)**:
    * [cite_start]An Nginx server receives the HTTP request and serves the static `index.html` registration form. [cite: 474]
    * [cite_start]When the user submits the form, the Web Tier Nginx acts as a **reverse proxy**, forwarding the `submit.php` request to the private IP address of the Application Tier server. [cite: 475]
3.  **Application Tier (Private Subnet)**:
    * [cite_start]An Nginx server receives the forwarded request from the Web Tier and passes it to the PHP-FPM service for processing. [cite: 476]
    * [cite_start]The `submit.php` script handles the application logic, connects to the database, and inserts the new user information. [cite: 477]
4.  **Database Tier (Private Subnet)**:
    * [cite_start]The RDS MySQL instance receives the database connection exclusively from the Application Tier. [cite: 478] [cite_start]This is strictly enforced by AWS Security Groups. [cite: 478]
    * [cite_start]The user data is then securely stored in the database. [cite: 478]

---

### Security Features

Security is a core component of this architecture, implemented through several AWS services:

* [cite_start]**Network Isolation**: The Application and Database Tiers are located in private subnets, making them inaccessible from the public internet. [cite: 481] [cite_start]Only the Web Tier is publicly accessible. [cite: 480]
* [cite_start]**Firewall Control**: AWS Security Groups act as stateful firewalls, enforcing strict rules on what traffic is allowed between the tiers. [cite: 482]
* [cite_start]**Controlled Outbound Access**: A NAT Gateway allows instances in the private subnets (like the App Tier) to access the internet for essential tasks like software updates, without exposing them to inbound connections. [cite: 483]

---

### Prerequisites

To deploy this infrastructure, you will need the following installed and configured:

* [cite_start]An AWS Account with appropriate permissions. [cite: 489]
* [cite_start]AWS CLI installed and configured (`aws configure`). [cite: 490]
* [cite_start]Terraform installed. [cite: 491]
* [cite_start]Ansible installed. [cite: 492]
* [cite_start]An SSH key pair generated in your target AWS region. [cite: 493]

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
    * [cite_start]Navigate to the `terraform/` directory. [cite: 499]
    * [cite_start]Rename the example variables file: `mv terraform.tfvars.example terraform.tfvars`. [cite: 500]
    * [cite_start]Edit `terraform.tfvars` with your AWS region, the name of your EC2 key pair, and desired database credentials. [cite: 501]

3.  **Deploy AWS Infrastructure with Terraform**
    [cite_start]From the `terraform/` directory, run the following commands. [cite: 503]
    * Initialize Terraform to download the necessary providers.
        ```bash
        terraform init
        ```
        [cite_start][cite: 504]
    * Apply the configuration to create the resources. Terraform will show you a plan and ask for confirmation.
        ```bash
        terraform apply
        ```
        [cite_start][cite: 505]
    * Review the plan and type `yes` to proceed. [cite_start]This process will build all AWS resources and automatically generate the `ansible/inventory.ini` file. [cite: 506]

4.  **Configure Servers with Ansible**
    [cite_start]Once the infrastructure is running, navigate to the `ansible/` directory and use the playbooks to install and configure the software. [cite: 508]
    ```bash
    ansible-playbook web_setup.yml
    ansible-playbook app_setup.yml
    ansible-playbook db_setup.yml
    ```
    [cite_start][cite: 510, 511, 512]

5.  **Verify the Deployment**
    [cite_start]Open a web browser and navigate to the `web_server_public_ip` provided in the Terraform output to see the running application. [cite: 514] [cite_start]The registration form should be visible and functional. [cite: 515]

---

### Demonstration

[cite_start]Here are screenshots demonstrating the successfully deployed and functional application. [cite: 517]

**The Registration Form:**
![The Registration Form](https://i.imgur.com/k91B6sL.png)

**Successful Submission Message:**
![Successful Submission Message](https://i.imgur.com/8QdY6tB.png)
