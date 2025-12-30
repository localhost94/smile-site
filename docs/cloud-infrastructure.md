# UNDPINDO - SMILE Platform Development and Upgrades : SMILE Cloud Infrastructure

UNDPINDO - SMILE Platform Development and Upgrades : SMILE Cloud Infrastructure  

1.  [Home](../index.html)
2.  [DPG Tasks Tracker](dpg/tasks-tracker.md)
3.  [Deployment Guide](deployment-guide.md)
4.  [Technical Overview](technical-overview.md)
5.  [Data Streaming](data-streaming.md)
8.  [SMILE Technical Overview Document](./SMILE-Technical-Overview-Document_5805277215.html)

# UNDPINDO - SMILE Platform Development and Upgrades : SMILE Cloud Infrastructure

This article was last updated on 26 Jun 2025

/\*<!\[CDATA\[\*/ div.rbtoc1766968432309 {padding: 0px;} div.rbtoc1766968432309 ul {list-style: default;margin-left: 0px;} div.rbtoc1766968432309 li {margin-left: 0px;padding-left: 0px;} /\*\]\]>\*/

-   [About](#SMILECloudInfrastructure-About)
-   [Cloud Infrastructure](#SMILECloudInfrastructure-CloudInfrastructure)
-   [Environment Structure](#SMILECloudInfrastructure-EnvironmentStructure)
-   [Infrastructure Requirements](#SMILECloudInfrastructure-InfrastructureRequirements)
    -   [Application Requirement](#SMILECloudInfrastructure-ApplicationRequirement)
    -   [Data Analysis Requirements](#SMILECloudInfrastructure-DataAnalysisRequirements)
    -   [Other Resources Requirements](#SMILECloudInfrastructure-OtherResourcesRequirements)
-   [Architecture Diagram](#SMILECloudInfrastructure-ArchitectureDiagram)
-   [Network Architecture](#SMILECloudInfrastructure-NetworkArchitecture)
-   [Compute Resources](#SMILECloudInfrastructure-ComputeResources)
    -   [Kubernetes Clusters (EKS)](#SMILECloudInfrastructure-KubernetesClusters(EKS))
        -   [Application Cluster](#SMILECloudInfrastructure-ApplicationCluster)
        -   [Data Cluster](#SMILECloudInfrastructure-DataCluster)
    -   [EC2 Instances](#SMILECloudInfrastructure-EC2Instances)
-   [Database Services](#SMILECloudInfrastructure-DatabaseServices)
    -   [MySQL RDS Instances](#SMILECloudInfrastructure-MySQLRDSInstances)
-   [Messaging & Caching](#SMILECloudInfrastructure-Messaging&Caching)
-   [Storage](#SMILECloudInfrastructure-Storage)
-   [Container Registry](#SMILECloudInfrastructure-ContainerRegistry)
-   [Supporting AWS Services](#SMILECloudInfrastructure-SupportingAWSServices)
-   [Security & Access](#SMILECloudInfrastructure-Security&Access)
-   [Monitoring & Observability](#SMILECloudInfrastructure-Monitoring&Observability)
-   [Traffic & CI/CD Flow](#SMILECloudInfrastructure-Traffic&CI/CDFlow)
-   [Revision History](#SMILECloudInfrastructure-RevisionHistory)

# About

---

This document provides a comprehensive architectural overview of the SMILE application’s cloud infrastructure and deployment strategy across its Development, Staging, and Production environments. The application is deployed on Amazon Web Services (AWS) within the **Jakarta Region (ap-southeast-3)** and utilises **Kubernetes (Amazon EKS)** for container orchestration.

It outlines the structure and purpose of each environment, key AWS services used, Kubernetes namespace segregation, CI/CD workflows, traffic routing, observability tooling, and security configurations. The goal is to offer a clear understanding of how SMILE is deployed, maintained, and monitored in a scalable, secure, and automated cloud-native ecosystem.

# Cloud Infrastructure

---

-   **Cloud Provider**: AWS
    
-   **Region**: `ap-southeast-3` (Jakarta)
    
-   **Orchestration**: Amazon EKS (Elastic Kubernetes Service)
    
-   **Data Layer**: Amazon RDS, Kafka, Debezium, RisingWave, Pentaho
    
-   **Security & Networking**: VPC, NAT Gateway, Bastion, Route53, Cloudflare
    

# Environment Structure

---

| Environment | Purpose | Deployment Target | Notes |
| --- | --- | --- | --- |
| Dev | Developer testing, previews | AWS Cloud / Ephemeral EKS or shared Dev cluster | May share some infrastructure; automated deployment from feature branches. |
| Staging | Pre-prod testing, QA, validation | *-uat clusters on AWS (EKS, RDS, etc.) | Mirror the production structure for testing and validation. |
| Production | Live workloads | Fully isolated AWS infrastructure | High-availability, security-hardened, scaling-enabled. |

# Infrastructure Requirements

---

The following requirements are applicable to deployments in Indonesia; specifications may vary in other countries.

## Application Requirement

| Resource | Qty | Details | Comments |
| --- | --- | --- | --- |
| Amazon ECR | 1 | 1TB Storage – 1TB transfer |  |
| EKS Cluster (Application Cluster) | 1 | EKS Cluster |  |
| Amazon EC2 | 5 | m6g.2xlarge8vCPU32 GiB Memory200GB Disk | Hosted on Application EKS Cluster |
| Amazon RDS | 1 | db.m5.4xlargevCPU: 16Memory: 64 GiB1TB | Common for both App and Data setup |
| Amazon ElastiCache | 1 | Cache m5.xLarge | Agreed: Use AWS Managed service |
| Amazon MQ | 1 | mq.m5.large |
| Amazon ALB | 4 | Application LB |  |
| Amazon API Gateway | 1 | API Gateway | Agreed: Not in use for now, we will use it as per App requirement in future |
| AWS Secrets Manager | 10 | Secrets Manager |  |
| Amazon EC2 | 2 | m6g.2xlarge 8vCPU32 GiB Memory 200GB | WMS Estimation |
| Amazon RDS | 1 | db.m5.2xlarge | WMS Estimation |

## Data Analysis Requirements

| Resource | Qty | Details | Comments |
| --- | --- | --- | --- |
| OLTP:Amazon RDS - My SQL(App DB) | 1 | Same RDS Instance to be used, as mentioned above |  |
| EKS Cluster (Data Cluster) | 1 |  |  |
| Amazon OLAP(Clickhouse): Amazon EC2 | 5 Nodes | d3en.2xlarge8 vCPUs32 GiB Memory | Hosted on Data EKS Cluster |
| Kafka: Amazon EC2 | 3 Nodes | d3en.2xlarge8 vCPUs32 GiB3TB | Hosted on Data EKS Cluster |
| Zookeeper Nodes: Amazon EC2 | 3 Nodes | d3en.2xlarge8 vCPUs32 GiB Memory3TB | Hosted on Data EKS Cluster |
| ETL (Pentaho): Amazon EC2 | 1 node | t3.2xlarge or m5.2xlarge8vCPUs32GB RAM250 GB storage | Hosted on Data EKS Cluster |

## Other Resources Requirements

| Resource | Quantity | Details | Comments |
| --- | --- | --- | --- |
| Security Hub | 1 | N/A |  |
| AWS Config | 1 | N/A |  |
| CloudTrail | 1 | N/A |  |
| GuardDuty | 1 | N/A |  |
| Cloudwatch | 1 | N/A |  |
| AWS Backup | 1 | N/A |  |
| S3 Buckets |  |  |  |
| Route 53 | 1 |  | For DNS records |
| Bastion Host + SSM |  | t3.large |  |
| Git repository | 1 | t3.xlarge(4:16) | Use one server across all the environments |

# Architecture Diagram

---

![image-20250522-045953.png](../../assets/attachments/5791318028/5791285281.png?width=760)

# Network Architecture

---

-   **VPC**: Single VPC with CIDR 10.0.0.0/16
    
-   **Subnets**:
    
    -   **EC2 Private**: For general compute resources
        
    -   **EKS Private**: For Kubernetes workloads
        
    -   **Intra**: For internal resources
        
    -   **Public**: For internet-facing resources
        
-   **NAT Gateway**: Enables outbound internet access for private resources
    
-   **Flow Logs**: Network traffic monitoring stored in S3
    

# Compute Resources

---

## Kubernetes Clusters (EKS)

![image-20250619-101810.png](../../assets/attachments/5791318028/5842698251.png?width=1280)

SMILE uses two separate EKS clusters:

### **Application Cluster**

**Purpose**: Runs the main application services

**Node Types**:

-   Main application nodes (ARM-based m6g.2xlarge)
    
-   WMS nodes (ARM-based m6g.xlarge)
    

### **Data Cluster**

**Purpose**: Handles data processing workloads

**Node Types**:

-   OLAP processing (d3en.2xlarge)
    
-   Kafka messaging (d3en.2xlarge)
    
-   Zookeeper coordination (d3en.2xlarge)
    
-   ETL processing (t3.2xlarge)
    
-   ClickHouse database (d3en.2xlarge)
    

## EC2 Instances

**Bastion Host**: Secure jump server for accessing private resources

-   **Instance Type**: t3.small
    
-   **Purpose**: SSH access to private network resources
    

# Database Services

---

### MySQL RDS Instances

| Database | Engine | Size | Backups |
| --- | --- | --- | --- |
| Main Application | MySQL 8.0 | db.m5.4xlarge500GB storage | Daily with 7-day retention |
| Waste Management System | MySQL 8.0 | db.m5.xlarge200GB storage | Daily with 7-day retention |

# Messaging & Caching

---

| Service | Purpose | Version | Instance |
| --- | --- | --- | --- |
| AmazonMQ (RabbitMQ) | Application messaging and event handling | 3.13 | mq.m5.large |
| ElastiCache (Redis) | Application caching and session management | 6.2 | cache.m5.xlarge |

# Storage

---

**S3 Buckets**:

-   Application data
    
-   Network flow logs (30-day retention)
    
-   Observability data (Loki and Tempo)
    

# Container Registry

---

**ECR Repositories** for application components:

-   Backend services (core, main, platform, auth, sync, warehouse)
    
-   Frontend web application
    
-   WMS services (backend, frontend, mobile, BFF)
    
-   Lifecycle policy: Untagged images removed after 14 days
    

# Supporting AWS Services

---

-   **Amazon Relational Database Service (RDS)**: Relational data storage;
    
-   **Amazon Elastic Kubernetes Service (EKS)**: Running Kubernetes cluster on AWS;
    
-   **Amazon ElastiCache**: Caching purpose;
    
-   **Amazon Message Queueing (MQ)**: Message broker;
    
-   **Amazon Simple Storage Service (S3)**: File and object storage;
    
-   **Amazon Secrets Manager**: Secret storage (DB creds, API keys);
    
-   **Amazon Backup**: Backup service.
    

# Security & Access

---

-   **Cloudflare**: DNS and edge security;
    
-   **Route 53**: Internal/external routing;
    
-   **Bastion host**: Access gateway to private subnet;
    
-   **NAT Gateway**: Enables private subnet access to the internet (e.g., for updates).
    
-   **Security Groups**: Defined for each service with least-privilege access
    
-   **IAM**: Infrastructure user with appropriate permissions
    
-   **Secrets Manager**: Secure storage for application credentials
    
-   **WAF**: Web Application Firewall protecting the application cluster
    

# Monitoring & Observability

---

-   **Prometheus + Grafana**: Metrics and dashboards;
    
-   **Jaeger**: Tracing;
    
-   **Loki**: Log aggregation;
    
-   **OTel Collector**: Unified telemetry collection.
    

# Traffic & CI/CD Flow

---

1.  **External Traffic**: Hits Cloudflare → Route 53 → Load Balancer → EKS (via Istio);
    
2.  **Internal Communication**: Services communicate securely via Istio (Service Mesh);
    
3.  **CI/CD Pipeline**:
    
    -   **GitLab**: Source Code Management (SCM)
        
    -   **Jenkins**: Build and deployment automation
        

# Revision History

---

**Internal Use Only. This content is not intended for publication in the live environment.**

| Date | Change description | Author | Status |
| --- | --- | --- | --- |
| 07 Jul 2025 | Added new input from Infra Team | TW | Done |
| 26 Jun 2025 | Proofread content. | Lead TW | Done |
| 19 Jun 2025 | Updated on some sections and reviewed by SA | TW | Done |
| 22 May 2025 | Initial Document | TW | Done |

## Attachments:

![](../../assets/images/icons/bullet_blue.gif) [image-20250522-045953.png](../../assets/attachments/5791318028/5791285281.png) (image/png)  
![](../../assets/images/icons/bullet_blue.gif) [image-20250619-101810.png](../../assets/attachments/5791318028/5842698251.png) (image/png)  

Document generated by Confluence on Dec 29, 2025 00:33

[Atlassian](http://www.atlassian.com/)