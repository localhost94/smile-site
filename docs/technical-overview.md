# UNDPINDO - SMILE Platform Development and Upgrades : SMILE Technical Overview Document

UNDPINDO - SMILE Platform Development and Upgrades : SMILE Technical Overview Document  

1.  [Home](../index.html)
2.  [DPG Tasks Tracker](dpg/tasks-tracker.md)
3.  [Deployment Guide](deployment-guide.md)
4.  [Cloud Infrastructure](cloud-infrastructure.md)
5.  [Data Streaming](data-streaming.md)

# UNDPINDO - SMILE Platform Development and Upgrades : SMILE Technical Overview Document

This article was last updated on 26 Jun 2025

/\*<!\[CDATA\[\*/ div.rbtoc1766968429962 {padding: 0px;} div.rbtoc1766968429962 ul {list-style: default;margin-left: 0px;} div.rbtoc1766968429962 li {margin-left: 0px;padding-left: 0px;} /\*\]\]>\*/

-   [Purpose](#SMILETechnicalOverviewDocument-Purpose)
-   [Scope](#SMILETechnicalOverviewDocument-Scope)
-   [System Architecture Overview](#SMILETechnicalOverviewDocument-SystemArchitectureOverview)
-   [Technology Stack](#SMILETechnicalOverviewDocument-TechnologyStack)
-   [Data Pipeline Architecture](#SMILETechnicalOverviewDocument-DataPipelineArchitecture)
-   [Infrastructure Requirements](#SMILETechnicalOverviewDocument-InfrastructureRequirements)
-   [Scalability Considerations](#SMILETechnicalOverviewDocument-ScalabilityConsiderations)
-   [Security Overview](#SMILETechnicalOverviewDocument-SecurityOverview)
-   [Dependencies & External Integrations](#SMILETechnicalOverviewDocument-Dependencies&ExternalIntegrations)
-   [Revision History](#SMILETechnicalOverviewDocument-RevisionHistory)

# Purpose

---

This document acts as a comprehensive reference for technical leads, developers, integrators, and external evaluators.

# Scope

---

This document encompasses all essential technical components, including frontend, backend, data pipeline, and infrastructure requirements. However, it does not cover low-level code documentation or API specifications.

# System Architecture Overview

---

![image-20250522-045953.png](../../assets/attachments/5805277215/5830934998.png?width=774)

For detailed information about System Architecture and Deployment, please visit the [**Cloud Infrastructure and Deployment**](./SMILE-Cloud-Infrastructure_5791318028.html) document.

# Technology Stack

---

![image-20250902-062740.png](../../assets/attachments/5805277215/5994971137.png?width=760)

| Layer | Technology / Framework | Description |
| --- | --- | --- |
| Frontend web platform | React.js,Next.js | SPA, responsive UI. |
| Backend | Bun,Hono | Bun as back-end runtime, and Hono as back-end framework. |
| Language Translation | Tolgee | Tolgee translates cross-language based on the current user’s selected language. |
| Frontend mobile platform | React Native | Cross-platform mobile development using React. |
| Database | MySQL as OLTPClickHouse as OLAP | MySQL for OLTP (Online Transaction Processing) and ClickHouse for OLAP (Online Analytical Processing). |
| Authentication | Keycloak / OAuth2 | Identity and access management. |
| Data Pipeline | Pentaho,Debezium,Kafka,dbt,RisingWave | Pentaho is used for data scheduling, while Debezium, Kafka, dbt, and RisingWave are used for Data Streaming. |
| Dashboard | Metabase | Dashboard visualisation. |
| Storage | MinIO | Storage caching, file storage, and backups in cloud or on-premises environments. |
| Monitoring | Prometheus,Elastic APM,Grafana,Open Telemetry | Object storage for caching, file storage, and backups in cloud or on-premises environments. |
| Message queue | RabbitMQ | Utilised as the message queue. |
| Cache | redis | In-memory caching and data storage to improve performance. |
| Notification | Firebase | Send notifications to users via Email and WhatsApp. |
| DevOps | Jenkins,Gitlab | CI/CD, containerization. |
| Infrastructure service | Kubernetes,Docker,AWS,Terraform,Ansible,OpenShift | Container orchestration for every service, containerization platform, and server service. |

# Data Pipeline Architecture

---

![image-20250619-105332.png](../../assets/attachments/5805277215/5842337859.png?width=760)

For detailed information about Data Pipeline architecture, please visit the [**Data Streaming Mechanism**](./Data-Streaming-Mechanism_5840994486.html) document.

# Infrastructure Requirements

---

For detailed information about the Infrastructure Requirements, please visit the [**SMILE Cloud Infrastructure**](./SMILE-Cloud-Infrastructure_5791318028.html) document

# Scalability Considerations

---

-   Stateless backend for horizontal scaling;
    
-   Use of caching (e.g., Redis) to reduce DB load;
    
-   Support for containerised deployment;
    
-   Asynchronous job handling (e.g., via queue or worker service);
    
-   Database indexing and performance tuning guidelines;
    
-   Cluster Autoscaler on EKS;
    
-   Kubernetes Horizontal Pod Autoscaler (HPA).
    

# Security Overview

---

-   Authentication and authorisation setup;
    
-   HTTPS enforcement;
    
-   Secrets management (e.g., environment variables or vaults);
    
-   Secure data storage practices (encryption at rest/in transit);
    
-   AWS Web Application Firewall;
    
-   AWS GuardDuty.
    

# Dependencies & External Integrations

---

| Service | Purpose | Service |
| --- | --- | --- |
| Firebase | Custom Notification | Cloud Messaging |
| Sentry | Real-time App Monitoring | Error Monitoring & Tracing |
| Expo | Testing, Framework (SDK), and Compiler for Mobile App | Expo SDK, Expo Go, and Build |

# Revision History

---

**Internal Use Only. This content is not intended for publication in the live environment.**

| Date | Change description | Author | Status |
| --- | --- | --- | --- |
| 02 Sep 2025 | Updated the latest Tech Stack graphic | TW | Done |
| 26 Jun 2025 | Content has been proofread and comments added to enhance readability. | Lead TW | Done |
| 24 Jun 2025 | All done. Ready for Review | TW | Done |
| 19 Jun 2025 | Reviewed and updated, only missing Infrastructure Requirements and Dependencies & External Integration | Infrastructure Team | Done |
| 16 Jun 2025 | Reviewed by PM and SA on some sections:System Architecture OverviewTechnology StackData Pipeline ArchitectureScalability Considerations | SA | Done |

![](../../assets/images/icons/grey_arrow_down.png)Older Revision History

| Date | Change description | Author | Status |
| --- | --- | --- | --- |
| 13 Jun 2025 | Updating some section that have been documented on other document; Getting Started Document. | TW | Done |
| 03 Jun 2025 | Initial document. | TW | Done |

## Attachments:

![](../../assets/images/icons/bullet_blue.gif) [undefined (1).png](../../assets/attachments/5805277215/5831328022.png) (image/png)  
![](../../assets/images/icons/bullet_blue.gif) [image-20250613-073706.png](../../assets/attachments/5805277215/5831426179.png) (image/png)  
![](../../assets/images/icons/bullet_blue.gif) [image-20250522-045953.png](../../assets/attachments/5805277215/5831655478.png) (image/png)  
![](../../assets/images/icons/bullet_blue.gif) [image-20250522-045953.png](../../assets/attachments/5805277215/5831589916.png) (image/png)  
![](../../assets/images/icons/bullet_blue.gif) [image-20250522-045953.png](../../assets/attachments/5805277215/5830934998.png) (image/png)  
![](../../assets/images/icons/bullet_blue.gif) [image-20250613-082923.png](../../assets/attachments/5805277215/5831786512.png) (image/png)  
![](../../assets/images/icons/bullet_blue.gif) [image-20250619-105332.png](../../assets/attachments/5805277215/5842337859.png) (image/png)  
![](../../assets/images/icons/bullet_blue.gif) [image-20250902-062740.png](../../assets/attachments/5805277215/5994971137.png) (image/png)  

Document generated by Confluence on Dec 29, 2025 00:33

[Atlassian](http://www.atlassian.com/)