# UNDPINDO - SMILE Platform Development and Upgrades : Deployment and Installation Guide

UNDPINDO - SMILE Platform Development and Upgrades : Deployment and Installation Guide  

1.  [Home](../index.html)
2.  [DPG Tasks Tracker](dpg/tasks-tracker.md)
3.  [Technical Overview](technical-overview.md)
4.  [Cloud Infrastructure](cloud-infrastructure.md)
5.  [Data Streaming](data-streaming.md)

# UNDPINDO - SMILE Platform Development and Upgrades : Deployment and Installation Guide

This article was last updated on 07 Jul 2025

/\*<!\[CDATA\[\*/ div.rbtoc1766968433259 {padding: 0px;} div.rbtoc1766968433259 ul {list-style: default;margin-left: 0px;} div.rbtoc1766968433259 li {margin-left: 0px;padding-left: 0px;} /\*\]\]>\*/

-   [About](#DeploymentandInstallationGuide-About)
-   [Environments](#DeploymentandInstallationGuide-Environments)
-   [Deployment Strategy](#DeploymentandInstallationGuide-DeploymentStrategy)
-   [File Structure](#DeploymentandInstallationGuide-FileStructure)
    -   [Application Structure](#DeploymentandInstallationGuide-ApplicationStructure)
    -   [Helm Chart Structure](#DeploymentandInstallationGuide-HelmChartStructure)
-   [How It Works](#DeploymentandInstallationGuide-HowItWorks)
    -   [Deployment Process](#DeploymentandInstallationGuide-DeploymentProcess)
    -   [Configuration Management](#DeploymentandInstallationGuide-ConfigurationManagement)
-   [Deployment Instructions](#DeploymentandInstallationGuide-DeploymentInstructions)
    -   [Prerequisites](#DeploymentandInstallationGuide-Prerequisites)
    -   [Initial Deployment](#DeploymentandInstallationGuide-InitialDeployment)
    -   [Deploying Individual Components](#DeploymentandInstallationGuide-DeployingIndividualComponents)
    -   [Updating Existing Infrastructure](#DeploymentandInstallationGuide-UpdatingExistingInfrastructure)
    -   [Destroying Infrastructure](#DeploymentandInstallationGuide-DestroyingInfrastructure)
    -   [Handling Deployment Errors](#DeploymentandInstallationGuide-HandlingDeploymentErrors)
    -   [Post-Deployment Configuration](#DeploymentandInstallationGuide-Post-DeploymentConfiguration)
-   [Common Tasks](#DeploymentandInstallationGuide-CommonTasks)
    -   [Adding a New Service](#DeploymentandInstallationGuide-AddingaNewService)
    -   [Scaling Resources](#DeploymentandInstallationGuide-ScalingResources)
    -   [Accessing Resources](#DeploymentandInstallationGuide-AccessingResources)
    -   [Monitoring & Backup](#DeploymentandInstallationGuide-Monitoring&Backup)
    -   [Backup & Disaster Recovery](#DeploymentandInstallationGuide-Backup&DisasterRecovery)
-   [Notes & Recommendations](#DeploymentandInstallationGuide-Notes&Recommendations)
-   [Revision History](#DeploymentandInstallationGuide-RevisionHistory)

# About

---

This document provides an overview of the SMILE5 application infrastructure deployed on AWS. The infrastructure is managed using Terragrunt and Terraform with support for multiple environments.

# Environments

---

| Environment | Purpose | Location |
| --- | --- | --- |
| Dev | Developer testing, previews | environments/dev |
| Staging | User Acceptance Testing, QA, validation | environments/uat |
| Production | Live application | environments/prod |

# Deployment Strategy

---

| Environment | Flow |
| --- | --- |
| Dev Commit | Developer completed the code;Developer requests an Merge-Request (MR) to Dev branch;System Analyst accepts the MR;The code is merged with the current Dev branch code;The code is deployed to the Dev environment. |
| Staging Commit | System Analyst analyses the code stability on the Dev environment;The code is stable on the Dev environment;System analyst running the pipeline for deployment;The code is merged with the current main/master branch code;The code is deployed to the Staging environment. |
| Production Commit | User Acceptance Testing (UAT) is conducted and approved on the Staging environment;System Analyst creates tagging with pattern vX.X.X from the main/master branch;The code is deployed to the Production environment. |

# File Structure

---

├── environments
│   ├── Makefile
│   ├── prod
│   │   ├── aws\_backup
│   │   │   └── terragrunt.hcl
│   │   ├── aws\_mq
│   │   │   └── terragrunt.hcl
│   │   ├── aws\_redis
│   │   │   └── terragrunt.hcl
│   │   ├── aws\_secrets
│   │   │   └── terragrunt.hcl
│   │   ├── aws\_waf
│   │   │   └── terragrunt.hcl
│   │   ├── buckets
│   │   │   └── terragrunt.hcl
│   │   ├── ec2
│   │   │   └── terragrunt.hcl
│   │   ├── ecr
│   │   │   └── terragrunt.hcl
│   │   ├── eks\_clusters
│   │   │   └── terragrunt.hcl
│   │   ├── iam
│   │   │   └── terragrunt.hcl
│   │   ├── rds
│   │   │   └── terragrunt.hcl
│   │   ├── route53
│   │   │   └── terragrunt.hcl
│   │   ├── security\_groups
│   │   │   └── terragrunt.hcl
│   │   ├── sg\_rule
│   │   │   └── terragrunt.hcl
│   │   ├── terragrunt.hcl
│   │   ├── vars.yaml
│   │   └── vpc
│   │       └── terragrunt.hcl
│   ├── tfsec-reports
│   └── uat
│       ├── aws\_backup
│       │   ├── terraform.tfvars.json
│       │   └── terragrunt.hcl
│       ├── aws\_mq
│       │   └── terragrunt.hcl
│       ├── aws\_redis
│       │   └── terragrunt.hcl
│       ├── aws\_secrets
│       │   └── terragrunt.hcl
│       ├── aws\_waf
│       │   └── terragrunt.hcl
│       ├── buckets
│       │   └── terragrunt.hcl
│       ├── ec2
│       │   └── terragrunt.hcl
│       ├── ecr
│       │   └── terragrunt.hcl
│       ├── eks\_clusters
│       │   └── terragrunt.hcl
│       ├── iam
│       │   └── terragrunt.hcl
│       ├── Makefile
│       ├── rds
│       │   └── terragrunt.hcl
│       ├── route53
│       │   └── terragrunt.hcl
│       ├── security\_groups
│       │   └── terragrunt.hcl
│       ├── sg\_rule
│       │   └── terragrunt.hcl
│       ├── terragrunt.hcl
│       ├── vars.yaml
│       └── vpc
│           └── terragrunt.hcl

## Application Structure

Explain what the user is downloading/cloning and how the repo or folder hierarchy is structured.

See the example below.

After cloning the project repository, the folder structure will look as follows:

project-root/
├── backend/                  # Backend services (API, database connectors)
│   ├── src/
│   ├── config/
│   └── package.json
├── frontend/                 # Web application frontend
│   ├── public/
│   ├── src/
│   └── package.json
├── mobile/                   # Mobile app (React Native)
│   ├── assets/
│   ├── src/
│   └── app.json
├── keycloak/                 # Authentication configurations and realm export
│   └── realm-export.json
├── scripts/                  # Deployment and migration scripts
│   ├── deploy.sh
│   └── migrate.sql
├── .env.example              # Environment variable template
├── docker-compose.yml        # Containerized deployment setup
├── README.md
└── INSTALLATION.md           # This installation guide

Notes:

-   **backend/**: Contains the core logic, API routes, and service configurations.
    
-   **frontend/**: Holds the React-based frontend app; needs to be built and served.
    
-   **mobile/**: React Native mobile app for Android/iOS deployment via Expo or native builds.
    
-   **keycloak/**: Used to configure Keycloak with pre-defined users, roles, and clients.
    
-   **scripts/**: Includes reusable scripts for database migration, deployment, or seeding.
    
-   **.env.example**: Use this file as a starting point to create your own `.env` configuration file.
    
-   **docker-compose.yml**: Simplifies the setup process using containers (if Docker is preferred).
    

## Helm Chart Structure

The structure for Kubernetes helm chart should be like this

templates/                     # Kubernetes manifests templates
  ├── deployment.yaml          # Deployment manifests for all services
  ├── service.yaml             # Service manifests for all services
  ├── hpa.yaml                 # Horizontal Pod Autoscaler manifests for all services
  ├── \_helpers.tpl             # Template helper functions
├── Chart.yaml                 # Chart metadata
├── values.yaml                # Default configuration values for all services

# How It Works

---

## Deployment Process

1.  Changes are made to the environment-specific vars.yaml file
    
2.  Terragrunt reads the configuration and generates Terraform code
    
3.  Terraform applies the changes to the AWS infrastructure
    
4.  Application deployments target the provisioned infrastructure
    

## Configuration Management

All environment-specific settings are stored in the vars.yaml file within each environment directory. This includes:

-   Network settings
    
-   Instance types and sizes
    
-   Security configurations
    
-   Storage settings
    

# Deployment Instructions

---

## Prerequisites

Before deploying the SMILE5 infrastructure, ensure you have the following prerequisites:

-   **AWS CLI** - Configured with appropriate credentials
    

aws configure

-   **Terraform** - Version 1.0.0 or later
    

terraform --version

-   **Terragrunt** - Version 0.35.0 or later
    

terragrunt --version

-   **kubectl** \- For interacting with Kubernetes clusters
    

kubectl version --client

-   **AWS IAM Permissions** - Ensure your AWS user has sufficient permissions to create all required resources
    

## Initial Deployment

To deploy the SMILE5 infrastructure for the first time:

1.  **Clone the Repository**
    

git clone <repository-url>
cd tf-aws-smile

2.  **Review and Customize Configuration** Edit the environment-specific vars.yaml file to adjust any settings:
    

\# Staging environment
vim environments/uat/vars.yaml 

# Production environment
vim environments/prod/vars.yaml

3.  **Initialize Terragrunt**
    

\# Staging environment 
terragrunt run-all init --terragrunt-working-dir=environments/uat 

# Production environment 
terragrunt run-all init --terragrunt-working-dir=environments/prod

4.  **Plan the Deployment**
    

\# Staging environment 
terragrunt run-all plan --terragrunt-working-dir=environments/uat 

# Production environment 
terragrunt run-all plan --terragrunt-working-dir=environments/prod

5.  **Apply the Configuration**
    

\# Staging environment 
terragrunt run-all apply --terragrunt-working-dir=environments/uat 

# Production environment 
terragrunt run-all apply --terragrunt-working-dir=environments/prod

When prompted, type yes to confirm the deployment.

6.  **Verify Deployment**  
    After deployment, verify the resources have been created correctly in the AWS console or using AWS CLI.
    

## Deploying Individual Components

SMILE5 infrastructure is modular. You can deploy specific components:

1.  **Deploy VPC Only**
    

\# Staging environment 
terragrunt run-all plan --terragrunt-working-dir=environments/uat/vpc 
terragrunt run-all apply --terragrunt-working-dir=environments/uat/vpc 

# Production environment 
terragrunt run-all plan --terragrunt-working-dir=environments/prod/vpc 
terragrunt run-all apply --terragrunt-working-dir=environments/prod/vpc

2.  **Deploy EKS Clusters**
    

\# Staging environment 
terragrunt run-all plan --terragrunt-working-dir=environments/uat/eks\_clusters 
terragrunt run-all apply --terragrunt-working-dir=environments/uat/eks\_clusters 

# Production environment 
terragrunt run-all plan --terragrunt-working-dir=environments/prod/eks\_clusters 
terragrunt run-all apply --terragrunt-working-dir=environments/prod/eks\_clusters

3.  **Deploy RDS Instances**
    

\# Staging environment 
terragrunt run-all plan --terragrunt-working-dir=environments/uat/rds 
terragrunt run-all apply --terragrunt-working-dir=environments/uat/rds 

# Production environment 
terragrunt run-all plan --terragrunt-working-dir=environments/prod/rds 
terragrunt run-all apply --terragrunt-working-dir=environments/prod/rds

## Updating Existing Infrastructure

To update the existing infrastructure:

1.  **Pull Latest Changes**
    

git pull

2.  **Update Configuration** Edit the environment-specific vars.yaml file with your changes:
    

\# Staging environment 
vim environments/uat/vars.yaml 

# Production environment vim environments/prod/vars.yaml

3.  **Plan Changes**
    

\# Staging environment 
terragrunt run-all plan --terragrunt-working-dir=environments/uat 

# Production environment 
terragrunt run-all plan --terragrunt-working-dir=environments/prod

Review the planned changes carefully.

4.  **Apply Changes**
    

\# Staging environment 
terragrunt run-all apply --terragrunt-working-dir=environments/uat 

# Production environment 
terragrunt run-all apply --terragrunt-working-dir=environments/prod

## Destroying Infrastructure

**CAUTION**: This will delete all resources. Use with extreme care!

To destroy the infrastructure (for example, in a development environment):

1.  **Plan the Destruction**
    

\# Staging environment 
terragrunt run-all plan -destroy --terragrunt-working-dir=environments/uat 

# Production environment 
terragrunt run-all plan -destroy --terragrunt-working-dir=environments/prod

2.  **Destroy Resources**
    

\# Staging environment 
terragrunt run-all destroy --terragrunt-working-dir=environments/uat 

# Production environment 
terragrunt run-all destroy --terragrunt-working-dir=environments/prod

When prompted, type yes to confirm.

## Handling Deployment Errors

If you encounter errors during deployment:

1.  Read Error Messages Terragrunt provides detailed error messages that can help identify the issue.
    
2.  Check AWS Console Sometimes resources may be created but not properly tracked by Terraform state.
    
3.  Run with Debug Logs
    

\# Staging environment 
terragrunt run-all apply --terragrunt-log-level debug --terragrunt-working-dir=environments/uat 

# Production environment 
terragrunt run-all apply --terragrunt-log-level debug --terragrunt-working-dir=environments/prod

## Post-Deployment Configuration

After successful deployment:

1.  **Configure kubectl for EKS Clusters**
    

aws eks update-kubeconfig --region ap-southeast-3 --name smile5-uat-app 
aws eks update-kubeconfig --region ap-southeast-3 --name smile5-uat-data

2.  **Verify EKS Connectivity**
    

kubectl get nodes

3.  **Access RDS Databases** Connect through the Bastion host:
    

ssh -i your-key.pem ec2-user@bastion-ip mysql -h rds-endpoint -u username -p

4.  **Set Up Application Secrets** Update the secrets in AWS Secrets Manager with actual values.
    

# Common Tasks

---

## Adding a New Service

1.  Add the required ECR repository in the ecr section of `vars.yaml`
    
2.  Add any required secrets in the `aws_secrets` section
    
3.  Apply the changes with Terragrunt
    
4.  Deploy the service to the appropriate EKS cluster
    

## Scaling Resources

To scale a component:

1.  Modify the appropriate section in `vars.yaml`:
    
    -   **For EKS**: Update `min_size`, `max_size`, and `desired_size`
        
    -   **For RDS**: Update `instance_class` or `allocated_storage`
        
2.  Apply the changes with Terragrunt
    

## Accessing Resources

-   **Databases**: Connect through the bastion host
    
-   **EKS Clusters**: Use kubectl with AWS authentication
    
-   **Private Services**: Access via the bastion host
    

## Monitoring & Backup

-   **RDS Monitoring**: Enhanced monitoring enabled (30-second intervals)
    
-   **Log Management**: VPC flow logs stored in dedicated S3 bucket
    
-   **Backup Plan**: Daily backups with 7-day retention
    

## Backup & Disaster Recovery

-   Backup service utilises the **Amazon Backup** service from AWS;
    
-   Backups will be conducted across **all three branches** (dev, staging, and production) that were created via Terraform;
    
-   Backups are targeted based on the **resource tag** on Terraform;
    
-   Backups are scheduled to **run daily at 03:00 Western Indonesian Time** (WIB) or 20:00 Coordinated Universal Time (UTC);
    
-   Backup retention policy period **will store** the backed-up data **for 7 days**.
    

# Notes & Recommendations

---

-   The infrastructure uses a single NAT gateway for cost optimization in UAT
    
-   Production environment should consider multi-AZ deployment for critical components
    
-   Security groups are configured for least-privilege access
    
-   Regular review of IAM permissions is recommended
    

# Revision History

---

**Internal Use Only. This content is not intended for publication in the live environment.**

| Date | Change description | Author | Status |
| --- | --- | --- | --- |
| 07 Jul 2025 | Created first draft and confirmed by Infra Team | TW | Done |
|  |  |  |  |
|  |  |  |  |

Document generated by Confluence on Dec 29, 2025 00:33

[Atlassian](http://www.atlassian.com/)