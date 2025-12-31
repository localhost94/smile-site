# UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Infrastruktur Cloud SMILE

UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Infrastruktur Cloud SMILE

1.  [Beranda](../../index.html?lang=id)
2.  [Pelacak Tugas DPG](dpg/tasks-tracker.md)
3.  [Panduan Deploy](deployment-guide.md)
4.  [Ikhtisar Teknis](technical-overview.md)
5.  [Streaming Data](data-streaming.md)
8.  [Dokumen Ikhtisar Teknis SMILE](./SMILE-Technical-Overview-Document_5805277215.html)

# UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Infrastruktur Cloud SMILE

Artikel ini diperbarui terakhir pada 26 Jun 2025

## Tentang

---

Dokumen ini memberikan ikhtisar arsitektur komprehensif mengenai infrastruktur cloud aplikasi SMILE dan strategi deploy di berbagai lingkungan Development, Staging, dan Production. Aplikasi ini di-deploy di Amazon Web Services (AWS) dalam **Wilayah Jakarta (ap-southeast-3)** dan menggunakan **Kubernetes (Amazon EKS)** untuk orkestrasi container.

Dokumen ini menguraikan struktur dan tujuan setiap lingkungan, layanan AWS utama yang digunakan, segregasi namespace Kubernetes, alur kerja CI/CD, perutean lalu lintas, tooling observability, dan konfigurasi keamanan. Tujuannya adalah untuk memberikan pemahaman yang jelas tentang bagaimana SMILE di-deploy, dipelihara, dan dipantau dalam ekosistem cloud-native yang skalabel, aman, dan terotomatisasi.

## Infrastruktur Cloud

### Arsitektur Tingkat Tinggi

SMILE menggunakan arsitektur microservices dengan komponen-komponen berikut:

- **Frontend**: Aplikasi web React yang di-host di S3 dan CloudFront
- **Backend**: API Gateway yang mengarah ke layanan microservices
- **Services**: Microservices yang berjalan di EKS
- **Database**: MySQL RDS untuk data transaksional
- **Cache**: Redis ElastiCache untuk caching
- **Queue**: SQS untuk antrian pesan
- **Storage**: S3 untuk penyimpanan file

### Layanan AWS yang Digunakan

#### Komputasi
- **EKS (Elastic Kubernetes Service)**: Orkestrasi container
- **EC2**: Instance untuk worker nodes dan bastion
- **Lambda**: Fungsi tanpa server untuk tugas spesifik

#### Database & Storage
- **RDS (Relational Database Service)**: Database MySQL
- **ElastiCache**: Redis untuk caching
- **S3 (Simple Storage Service)**: Penyimpanan objek
- **EFS (Elastic File System)**: File system bersama

#### Jaringan
- **VPC (Virtual Private Cloud)**: Jaringan virtual terisolasi
- **Route 53**: DNS dan routing lalu lintas
- **CloudFront**: CDN untuk akselerasi konten
- **ALB (Application Load Balancer)**: Load balancing untuk aplikasi

#### Keamanan
- **IAM (Identity and Access Management)**: Kontrol akses
- **Secrets Manager**: Manajemen rahasia
- **KMS (Key Management Service)**: Enkripsi
- **WAF (Web Application Firewall)**: Firewall aplikasi web

#### Monitoring & Observability
- **CloudWatch**: Monitoring dan logging
- **X-Ray**: Tracing aplikasi
- **CloudTrail**: Audit trail

## Struktur Lingkungan

### Development Environment

- **Tujuan**: Pengembangan dan testing fitur baru
- **Namespace**: `smile5-dev`
- **Replicas**: 1-2 per service
- **Resources**: Minimal, on-demand
- **Database**: RDS instance kecil (db.t3.micro)

### Staging Environment

- **Tujuan**: Pra-produksi dan validasi akhir
- **Namespace**: `smile5-staging`
- **Replicas**: 2-3 per service
- **Resources**: Sedang, reserved
- **Database**: RDS instance sedang (db.t3.medium)

### Production Environment

- **Tujuan**: Layanan produksi untuk pengguna akhir
- **Namespace**: `smile5-prod`
- **Replicas**: 3+ per service
- **Resources**: Tinggi, auto-scaling
- **Database**: RDS instance besar dengan Multi-AZ (db.r5.large)

## Persyaratan Infrastruktur

### Persyaratan Aplikasi

#### CPU dan Memory
- **API Services**: 500m-2000m CPU, 512Mi-4Gi memory
- **Background Workers**: 250m-1000m CPU, 256Mi-2Gi memory
- **Frontend**: Minimal, di-serve oleh CDN

#### Storage
- **Database**: 100GB-1TB tergantung lingkungan
- **File Storage**: 500GB-5TB untuk dokumen dan media
- **Logs**: 50GB-200GB dengan rotasi

### Persyaratan Analisis Data

#### Processing Power
- **ETL Jobs**: 2-4 vCPU, 8-16Gi memory
- **Analytics Engine**: Spark cluster dengan 3-5 nodes
- **ML Pipeline**: GPU opsional untuk training model

#### Data Pipeline
- **Throughput**: 10K-100K events per detik
- **Latency**: < 100ms untuk real-time processing
- **Retention**: 7 tahun untuk data audit

### Persyaratan Sumber Daya Lainnya

#### Network
- **Bandwidth**: 1Gbps-10Gbps
- **Latency**: < 50ms intra-region
- **Redundancy**: Multi-AZ deployment

#### Backup & DR
- **RPO**: 15 menit
- **RTO**: 4 jam
- **Retention**: 30 hari backup, 7 tahun arsip

## Diagram Arsitektur

```
┌─────────────────────────────────────────────────────────────┐
│                        Internet                             │
└─────────────────────┬───────────────────────────────────────┘
                      │
              ┌───────▼───────┐
              │   CloudFront  │
              │     CDN       │
              └───────┬───────┘
                      │
              ┌───────▼───────┐
              │ Route 53 DNS  │
              └───────┬───────┘
                      │
              ┌───────▼───────┐
              │  ALB/WAF      │
              │ Load Balancer │
              └───────┬───────┘
                      │
          ┌───────────▼───────────┐
          │      EKS Cluster      │
          │   (Kubernetes)        │
          │                       │
          │ ┌─────┐ ┌─────┐ ┌─────┐│
          │ │API  │ │Web  │ │Jobs ││
          │ │Svcs │ │Svcs │ │Svcs ││
          │ └─────┘ └─────┘ └─────┘│
          └───────────┬───────────┘
                      │
    ┌─────────────────▼─────────────────┐
    │                                   │
┌───▼───┐                         ┌─────▼────┐
│  RDS  │                         │ElastiCache│
│ MySQL │                         │  Redis   │
└───────┘                         └──────────┘
```

## Arsitektur Jaringan

### VPC Configuration

- **CIDR Block**: 10.0.0.0/16
- **Availability Zones**: 3 AZs (ap-southeast-3a, b, c)
- **Subnets**: 6 subnets (3 public, 3 private)
- **NAT Gateways**: 1 per AZ untuk outbound internet

### Security Groups

#### Application SG
- **Inbound**: 443 dari ALB
- **Outbound**: 443, 80 ke internet
- **Port**: 8080 untuk health checks

#### Database SG
- **Inbound**: 3306 dari application SG
- **Outbound**: Tidak ada
- **Encryption**: TLS enforced

### Network ACLs

- **Public Subnets**: HTTP/HTTPS inbound, semua outbound
- **Private Subnets**: HTTPS outbound ke VPC endpoints
- **Database Subnets**: Database traffic only

## Sumber Daya Komputasi

### Kubernetes Clusters (EKS)

#### Application Cluster
- **Version**: v1.24
- **Node Groups**: 3 types (web, api, batch)
- **Auto-scaling**: 2-50 nodes per group
- **Instance Types**: m5.large, m5.xlarge, c5.2xlarge

#### Data Cluster
- **Version**: v1.24
- **Node Groups**: 2 types (compute, memory)
- **Auto-scaling**: 1-20 nodes per group
- **Instance Types**: r5.large, r5.xlarge

### EC2 Instances

#### Bastion Host
- **Purpose**: Akses SSH ke private resources
- **Instance**: t3.micro
- **Security**: Key-based auth only
- **Logging**: Semua sesi di-log

#### Worker Nodes
- **Purpose**: EKS worker nodes
- **Configuration**: 30-100Gi storage, 2-16 vCPU
- **AMIs**: Amazon Linux 2 EKS optimized
- **Monitoring**: CloudWatch agent installed

## Layanan Database

### MySQL RDS Instances

#### Production
- **Engine**: MySQL 8.0
- **Instance**: db.r5.large
- **Storage**: 500GB SSD, auto-scaling
- **HA**: Multi-AZ deployment
- **Backup**: Daily snapshots, 30 hari retention

#### Staging
- **Engine**: MySQL 8.0
- **Instance**: db.t3.medium
- **Storage**: 100GB SSD
- **HA**: Single AZ
- **Backup**: Daily snapshots, 7 hari retention

#### Development
- **Engine**: MySQL 8.0
- **Instance**: db.t3.micro
- **Storage**: 20GB SSD
- **HA**: Single AZ
- **Backup**: Manual snapshots

## Messaging & Caching

### SQS Queues
- **Standard Queue**: Untuk processing asinkron
- **FIFO Queue**: Untuk message ordering
- **DLQ**: Dead letter queue untuk failed messages
- **Retention**: 14 hari

### ElastiCache Redis
- **Cluster Mode**: Enabled untuk scaling
- **Replicas**: 1 primary, 2 replicas
- **Sharding**: 2 shards
- **Persistence**: Snapshot setiap 6 jam

## Storage

### S3 Buckets
- **smile5-assets**: Static assets (CSS, JS, images)
- **smile5-documents**: User documents
- **smile5-backups**: Database backups
- **smile5-logs**: Log files

### EFS
- **Mount Target**: 1 per AZ
- **Throughput**: 100 MB/s
- **Encryption**: At-rest encryption enabled
- **Backup**: Daily backups enabled

## Container Registry

### ECR Repository
- **Repositories**: 1 per microservice
- **Lifecycle Policy**: Keep 100 versions, delete setelah 30 hari
- **Scanning**: Security scan pada push
- **Access**: IAM-based access control

## Layanan Pendukung AWS

### CloudFormation
- **Stacks**: 1 per environment
- **Templates**: YAML format
- **Drift Detection**: Diaktifkan
- **Rollback**: Otomatis pada failure

### Systems Manager
- **Parameter Store**: Konfigurasi aplikasi
- **Run Command**: Patch management
- **Automation**: Maintenance tasks
- **Session Manager**: Akses tanpa SSH

## Keamanan & Akses

### IAM Roles
- **EKS Node Role**: Untuk worker nodes
- **Service Roles**: Untuk setiap layanan AWS
- **Task Roles**: Untuk ECS/Fargate tasks
- **Least Privilege**: Prinsip least privilege diterapkan

### Secrets Management
- **Secrets Manager**: Untuk database credentials
- **Environment Variables**: Untuk konfigurasi non-sensitif
- **Rotation**: Otomatis untuk database passwords
- **Audit**: Semua akses di-audit

### Compliance
- **SOC 2**: Compliance requirements
- **Data Residency**: Data tetap di Indonesia
- **Encryption**: Data dienkripsi di-rest dan in-transit
- **Audit Logs**: Semua akses di-log

## Monitoring & Observability

### CloudWatch Metrics
- **Custom Metrics**: Application metrics
- **Standard Metrics**: AWS service metrics
- **Alarms**: Threshold-based alerts
- **Dashboards**: Grafik real-time

### X-Ray Tracing
- **Services**: Semua microservices
- **Sampling**: 10% untuk production
- **Annotations**: Custom metadata
- **Analytics**: Performance insights

### Logging
- **CloudWatch Logs**: Centralized logging
- **Log Formats**: JSON structured
- **Retention**: 30 hari
- **Insights**: Query dan analysis

## Lalu Lintas & Alur CI/CD

### Traffic Routing
- **Blue/Green**: Untuk production deploy
- **Canary**: 10% traffic untuk testing
- **Weighted**: Gradual traffic shifting
- **Health Checks**: Automated health validation

### CI/CD Pipeline
1. **Code Commit**: Push ke GitHub
2. **Build**: Docker image build
3. **Test**: Unit dan integration tests
4. **Security**: Vulnerability scanning
5. **Deploy**: Otomatis ke staging
6. **Approval**: Manual untuk production
7. **Release**: Blue/green deployment

## Riwayat Revisi

| Versi | Tanggal | Perubahan | Author |
|-------|---------|-----------|--------|
| 1.0 | 26 Jun 2025 | Versi awal | Tim SMILE |
| 1.1 | 30 Jun 2025 | Update diagram arsitektur | Tim SMILE |
| 1.2 | 05 Jul 2025 | Tambah detail monitoring | Tim SMILE |
