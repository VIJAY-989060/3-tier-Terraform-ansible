# 3-Tier Web Application Deployment on AWS using Terraform and Ansible

> This repository contains a complete Infrastructure-as-Code (IaC) solution for deploying a scalable and secure 3-tier web application on Amazon Web Services (AWS). The infrastructure is provisioned using Terraform, and the servers are configured automatically with Ansible.

This project demonstrates a foundational and secure cloud architecture, separating the application into Web, Application, and Database tiers for enhanced security and management.

---

### Table of Contents
- [Architecture Diagram](#architecture-diagram)
- [How the System Works](#how-the-system-works)
- [Security Features](#security-features)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Deployment Steps](#deployment-steps)
- [Verification](#verification)
- [Demonstration](#demonstration)

---

### Architecture Diagram

The architecture is designed with security as a priority. Only the Web Tier is exposed to public traffic, while the Application and Database tiers are isolated in private subnets.

* **Instruction:** Save the diagram from your document as an image file (e.g., `architecture-diagram.png`), upload it to your repository, and ensure the filename below matches.

![Architecture Diagram of the 3-Tier Application](architecture-diagram.png)

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

* **Network Isolation**: The Application and Database Tiers are located in private subnets, making them inaccessible from the public internet.
* **Firewall Control**: AWS Security Groups act as stateful firewalls, enforcing strict rules on what traffic is allowed between the tiers (e.g., only the App Tier can communicate with the DB Tier on port 3306).
* **Controlled Outbound Access**: A NAT Gateway allows instances in the private subnets (like the App Tier) to access the internet for essential tasks like software updates, without exposing them to inbound connections.
* **Public Access Control**: Only the Web Tier is publicly accessible to serve user traffic.

---

### Technologies Used

| Category | Technology / Service |
| :--- | :--- |
| **Infrastructure as Code** | Terraform |
| **Configuration Management**| Ansible |
| **Cloud Provider** | Amazon Web Services (AWS) |
| **Networking** | VPC, Public & Private Subnets, Internet Gateway, NAT Gateway |
| **Compute** | EC2 Instances |
| **Database** | RDS for MySQL |
| **Web Server** | Nginx (Web Server & Reverse Proxy) |
| **Application Logic** | PHP-FPM |

---

### Prerequisites

To deploy this infrastructure, you will need the following installed and configured on your local
