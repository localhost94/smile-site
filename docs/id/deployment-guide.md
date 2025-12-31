# UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Panduan Deploy dan Instalasi

UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Panduan Deploy dan Instalasi

1.  [Beranda](../../index.html?lang=id)
2.  [Pelacak Tugas DPG](dpg/tasks-tracker.md)
3.  [Ikhtisar Teknis](technical-overview.md)
4.  [Infrastruktur Cloud](cloud-infrastructure.md)
5.  [Streaming Data](data-streaming.md)

# UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Panduan Deploy dan Instalasi

Artikel ini diperbarui terakhir pada 07 Jul 2025

## Tentang

---

Dokumen ini memberikan ikhtisar mengenai infrastruktur aplikasi SMILE5 yang di-deploy di AWS. Infrastruktur ini dikelola menggunakan Terragrunt dan Terraform dengan dukungan untuk beberapa lingkungan.

## Lingkungan

### Lingkungan yang Didukung

- **Development**: Lingkungan pengembangan untuk pengujian fitur baru
- **Staging**: Lingkungan pra-produksi untuk validasi akhir
- **Production**: Lingkungan produksi untuk operasional sebenarnya

## Strategi Deploy

### Prinsip Utama

1. **Infrastructure as Code**: Semua infrastruktur dikelola melalui kode
2. **Automated Deployment**: Proses deploy diotomatisasi melalui CI/CD
3. **Zero Downtime**: Deploy tanpa mengganggu layanan yang berjalan
4. **Rollback Capability**: Kemampuan rollback ke versi sebelumnya

## Struktur File

### Struktur Aplikasi

```
smile5/
├── helm-charts/          # Chart Helm untuk Kubernetes
├── terraform/           # Konfigurasi Terraform
├── docker/              # Dockerfile dan konfigurasi
├── k8s/                 # Manifes Kubernetes
└── scripts/             # Script deploy dan utilitas
```

### Struktur Helm Chart

```
helm-charts/smile5/
├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-staging.yaml
├── values-prod.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml
    └── configmap.yaml
```

## Cara Kerja

### Proses Deploy

1. **Code Commit**: Developer push kode ke repository
2. **Build Pipeline**: CI/CD pipeline membangun Docker image
3. **Test Suite**: Automated testing dijalankan
4. **Security Scan**: Pemindaian keamanan dilakukan
5. **Deploy to Staging**: Deploy ke lingkungan staging
6. **Approval**: Persetujuan tim untuk produksi
7. **Deploy to Production**: Deploy ke lingkungan produksi

### Manajemen Konfigurasi

- **Environment Variables**: Variabel lingkungan disimpan di AWS Secrets Manager
- **ConfigMaps**: Konfigurasi aplikasi disimpan di Kubernetes ConfigMaps
- **Secrets**: Data sensitif dienkripsi dan disimpan secara aman

## Instruksi Deploy

### Prasyarat

#### Persyaratan Sistem

- **Kubernetes Cluster**: v1.24 atau lebih tinggi
- **Helm**: v3.8 atau lebih tinggi
- **kubectl**: Terkonfigurasi dengan akses cluster
- **AWS CLI**: Terkonfigurasi dengan kredensial yang tepat
- **Terraform**: v1.3 atau lebih tinggi
- **Terragrunt**: v0.41 atau lebih tinggi

#### Persyaratan Perangkat Lunak

- **Docker**: Untuk membangun image
- **Node.js**: v18 atau lebih tinggi
- **Python**: v3.9 atau lebih tinggi
- **Git**: Untuk kontrol versi

### Deploy Awal

#### 1. Clone Repository

```bash
git clone https://github.com/undp-indo/smile-platform.git
cd smile-platform
```

#### 2. Setup Infrastruktur

```bash
# Navigasi ke direktori terraform
cd terraform/environment/dev

# Inisialisasi Terraform
terragrunt init

# Terapkan infrastruktur
terragrunt apply
```

#### 3. Deploy Aplikasi

```bash
# Navigasi ke direktori helm
cd helm-charts/smile5

# Deploy ke development
helm install smile5-dev . -f values-dev.yaml

# Verifikasi deploy
kubectl get pods -n smile5-dev
```

### Deploy Komponen Individual

#### Deploy Backend Services

```bash
# Deploy database
helm install smile5-db ./database -f values-dev.yaml

# Deploy API services
helm install smile5-api ./api -f values-dev.yaml

# Deploy background workers
helm install smile5-workers ./workers -f values-dev.yaml
```

#### Deploy Frontend

```bash
# Build frontend
cd frontend
npm install
npm run build

# Deploy ke S3 dan CloudFront
aws s3 sync dist/ s3://smile5-dev-frontend
```

### Memperbarui Infrastruktur yang Ada

#### Update Versi Aplikasi

```bash
# Update image version
helm upgrade smile5-dev . -f values-dev.yaml --set image.tag=v1.2.3

# Restart pods jika perlu
kubectl rollout restart deployment/smile5-api -n smile5-dev
```

#### Update Konfigurasi

```bash
# Update ConfigMap
kubectl apply -f k8s/configmaps/

# Restart pods untuk memuat konfigurasi baru
kubectl rollout restart deployment/smile5-api -n smile5-dev
```

### Menghancurkan Infrastruktur

#### Hapus Aplikasi

```bash
# Hapus deployment Helm
helm uninstall smile5-dev

# Hapus namespace
kubectl delete namespace smile5-dev
```

#### Hapus Infrastruktur

```bash
# Navigasi ke direktori terraform
cd terraform/environment/dev

# Hapus semua sumber daya
terragrunt destroy
```

### Menangani Kesalahan Deploy

#### Masalah Umum

1. **Pod Gagal Start**
   - Periksa logs: `kubectl logs <pod-name>`
   - Periksa events: `kubectl describe pod <pod-name>`
   - Verifikasi image: `kubectl get pods -o wide`

2. **Service Tidak Dapat Diakses**
   - Periksa service: `kubectl get svc`
   - Periksa ingress: `kubectl get ingress`
   - Verifikasi endpoint: `kubectl get endpoints`

3. **Database Connection Error**
   - Periksa secret: `kubectl get secret`
   - Verifikasi kredensial
   - Test connectivity dari pod

#### Prosedur Pemecahan Masalah

1. **Identifikasi Masalah**
   - Kumpulkan logs dan metrics
   - Analisis root cause
   - Dokumentasikan temuan

2. **Implementasi Fix**
   - Terapkan patch
   - Test di staging
   - Deploy ke produksi

3. **Post-mortem**
   - Review proses
   - Update dokumentasi
   - Implementasi pencegahan

### Konfigurasi Pasca-Deploy

#### Monitoring

1. **Setup Prometheus**
   ```bash
   helm install prometheus prometheus-community/kube-prometheus-stack
   ```

2. **Configure Grafana**
   - Import dashboard SMILE
   - Setup alerts
   - Configure notifications

#### Backup

1. **Database Backup**
   ```bash
   # Setup automated backup
   kubectl apply -f k8s/backup-cronjob.yaml
   ```

2. **Disaster Recovery**
   - Document recovery procedures
   - Test restore process
   - Maintain backup retention

## Tugas Umum

### Menambahkan Layanan Baru

#### 1. Buat Dockerfile

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

#### 2. Buat Helm Chart

```yaml
# values.yaml
newService:
  image:
    repository: smile5/new-service
    tag: latest
  replicas: 3
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
```

#### 3. Deploy

```bash
helm install new-service ./charts/new-service
```

### Scaling Sumber Daya

#### Horizontal Scaling

```bash
# Scale deployment
kubectl scale deployment smile5-api --replicas=5 -n smile5-dev

# Atau via Helm
helm upgrade smile5-dev . -f values-dev.yaml --set api.replicas=5
```

#### Vertical Scaling

```bash
# Update resource limits
helm upgrade smile5-dev . -f values-dev.yaml --set api.resources.limits.cpu=1000m
```

### Mengakses Sumber Daya

#### Akses Database

```bash
# Port forward ke database
kubectl port-forward svc/smile5-db 5432:5432 -n smile5-dev

# Connect dengan psql
psql -h localhost -U smile5 -d smile5_dev
```

#### Akses Logs

```bash
# Stream logs real-time
kubectl logs -f deployment/smile5-api -n smile5-dev

# Logs dari pod spesifik
kubectl logs <pod-name> -n smile5-dev
```

### Monitoring & Backup

#### Setup Monitoring

1. **Metrics Collection**
   - Prometheus untuk metrics
   - Grafana untuk visualisasi
   - AlertManager untuk alerts

2. **Log Aggregation**
   - ELK Stack atau Fluentd
   - Centralized logging
   - Log retention policies

#### Backup & Disaster Recovery

1. **Automated Backups**
   - Database snapshots
   - File system backups
   - Configuration backups

2. **Recovery Procedures**
   - RTO/RPO targets
   - Recovery runbooks
   - Regular testing

## Catatan & Rekomendasi

### Best Practices

1. **Security**
   - Gunakan RBAC untuk akses control
   - Encrypt data sensitif
   - Regular security audits

2. **Performance**
   - Monitor resource usage
   - Optimize database queries
   - Implement caching

3. **Reliability**
   - Implement health checks
   - Use circuit breakers
   - Design for failure

### Rekomendasi

1. **Gunakan GitOps untuk manajemen infrastruktur**
2. **Implementasi automated testing di pipeline CI/CD**
3. **Regular backup dan test recovery procedures**
4. **Monitor dan alert untuk semua komponen kritis**

## Riwayat Revisi

| Versi | Tanggal | Perubahan | Author |
|-------|---------|-----------|--------|
| 1.0 | 07 Jul 2025 | Versi awal | Tim SMILE |
| 1.1 | 15 Jul 2025 | Update proses deploy | Tim SMILE |
| 1.2 | 20 Jul 2025 | Tambah troubleshooting | Tim SMILE |
