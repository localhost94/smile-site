# UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Streaming Data

UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Streaming Data

1.  [Beranda](../../index.html?lang=id)
2.  [Pelacak Tugas DPG](dpg/tasks-tracker.md)
3.  [Panduan Deploy](deployment-guide.md)
4.  [Ikhtisar Teknis](technical-overview.md)
5.  [Infrastruktur Cloud](cloud-infrastructure.md)

# UNDPINDO - Platform SMILE Pengembangan dan Peningkatan: Streaming Data

Artikel ini diperbarui terakhir pada 25 Jun 2025

## Tentang

---

Dokumen ini mendokumentasikan arsitektur streaming data SMILE, termasuk pemrosesan data real-time dan integrasi dengan berbagai sistem. Platform streaming data SMILE dirancang untuk menangani volume data besar dengan latensi rendah, memastikan informasi logistik vaksin tersedia secara real-time untuk pengambilan keputusan.

## Arsitektur Streaming Data

### Ikhtisar Arsitektur

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Sources   │───▶│   Ingest    │───▶│ Processing  │
│             │    │   Layer     │    │   Engine    │
│ • IoT       │    │             │    │             │
│ • APIs      │    │ • Kinesis   │    │ • Flink     │
│ • Databases │    │ • Kafka     │    │ • Spark     │
│ • Files     │    │ • SQS       │    │ • Lambda    │
└─────────────┘    └─────────────┘    └─────────────┘
                                             │
                                             ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Storage   │◀───│   Analytics │◀───│  Output     │
│             │    │   Layer     │    │  Destinations│
│ • S3        │    │             │    │             │
│ • Redshift  │    │ • EMR       │    │ • Dashboards│
│ • RDS       │    │ • Glue      │    │ • Alerts    │
│ • NoSQL     │    │ • Athena    │    │ • APIs      │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Komponen Utama

#### 1. Data Sources
- **IoT Sensors**: Suhu kulkas vaksin, GPS tracking
- **API Endpoints**: Entry data manual, integrasi sistem
- **Databases**: CDC (Change Data Capture) dari transaksional DB
- **File Sources**: Upload batch, eksternal feeds

#### 2. Ingestion Layer
- **Amazon Kinesis**: Streaming data real-time
- **Apache Kafka**: Message queue terdistribusi
- **SQS**: Antrian pesan sederhana
- **Direct Connect**: Koneksi dedicated untuk high-volume

#### 3. Processing Engine
- **Apache Flink**: Stream processing dengan state management
- **Apache Spark**: Batch dan micro-batch processing
- **AWS Lambda**: Event-driven functions
- **Step Functions**: Orchestration workflow

#### 4. Storage Layer
- **S3**: Data lake untuk raw dan processed data
- **Redshift**: Data warehouse untuk analytics
- **DynamoDB**: NoSQL untuk fast lookups
- **RDS**: Relational untuk structured data

#### 5. Output Destinations
- **QuickSight**: Business intelligence dashboards
- **SNS**: Real-time notifications
- **API Gateway**: External API access
- **EventBridge**: Event routing

## Sumber Data

### IoT Sensors

#### Temperature Sensors
- **Type**: DS18B20 digital sensors
- **Frequency**: Setiap 5 menit
- **Format**: JSON dengan timestamp, device_id, temperature
- **Volume**: ~1M events/hari

#### GPS Trackers
- **Type**: LTE-M GPS modules
- **Frequency**: Setiap 30 detik saat bergerak
- **Format**: GeoJSON dengan location, speed, heading
- **Volume**: ~5M events/hari

### API Endpoints

#### REST APIs
- **Vaccine Registration**: POST /api/v1/vaccines
- **Stock Updates**: PUT /api/v1/stock
- **Distribution Records**: POST /api/v1/distributions

#### GraphQL API
- **Real-time Queries**: Subscription untuk live updates
- **Batch Operations**: Bulk mutations
- **Analytics**: Complex data queries

### Database CDC

#### MySQL Binlog
- **Tool**: Debezium connector
- **Tables**: transactions, inventory, movements
- **Format**: Avro serialized
- **Latency**: < 100ms

#### PostgreSQL WAL
- **Tool**: pgoutput plugin
- **Tables**: users, facilities, schedules
- **Format**: Protobuf
- **Latency**: < 50ms

## Pemrosesan Real-time

### Stream Processing dengan Flink

#### Window Operations
```java
// 5-minute tumbling window untuk suhu
DataStream<TemperatureReading> readings = ...;
readings
    .keyBy(reading -> reading.getDeviceId())
    .window(TumblingEventTimeWindows.of(Time.minutes(5)))
    .aggregate(new TemperatureAggregator());
```

#### State Management
- **Keyed State**: Per-device metrics
- **Operator State**: Checkpoint data
- **Checkpointing**: Setiap 1 menit
- **State Backend**: RocksDB on S3

#### Event Time Processing
- **Watermarks**: Handling late data
- **Allowed Lateness**: 10 menit
- **Side Outputs**: Late events handling

### Batch Processing dengan Spark

#### ETL Jobs
```python
# Daily aggregation job
def process_daily_data():
    df = spark.read.format("parquet").load("s3://smile5/raw/")
    
    # Transformations
    aggregated = df.groupBy("facility_id").agg(
        count("*").alias("total_events"),
        avg("temperature").alias("avg_temp")
    )
    
    # Write to Redshift
    aggregated.write
        .format("jdbc")
        .option("url", redshift_url)
        .option("dbtable", "daily_metrics")
        .save()
```

#### Scheduling
- **AWS Glue**: Managed ETL
- **Airflow**: Workflow orchestration
- **Cron**: Traditional scheduling
- **Event-driven**: Trigger oleh data availability

## Integrasi Sistem

### External Systems

#### Ministry of Health API
- **Authentication**: OAuth 2.0
- **Rate Limit**: 1000 requests/menit
- **Retry Policy**: Exponential backoff
- **Data Format**: HL7 FHIR

#### UNDP Systems
- **Data Warehouse**: Snowflake integration
- **Analytics**: Tableau connectivity
- **Monitoring**: Grafana dashboards
- **Alerting**: PagerDuty integration

### Internal Services

#### Inventory Service
- **Input**: Stock movements
- **Output**: Real-time inventory levels
- **Latency**: < 1 detik
- **Throughput**: 10K updates/detik

#### Analytics Service
- **Input**: Aggregated data streams
- **Output**: KPI calculations
- **Latency**: < 5 detik
- **Refresh**: Real-time

## Monitoring Streaming

### Key Metrics

#### Throughput Metrics
- **Events/Second**: Total volume processing
- **Bytes/Second**: Data throughput
- **Records/Lag**: Consumer lag monitoring
- **Processing Time**: End-to-end latency

#### Quality Metrics
- **Error Rate**: Failed processing percentage
- **Duplicate Rate**: Deduplication effectiveness
- **Completeness**: Data completeness checks
- **Accuracy**: Validation error rates

### Alerting

#### Threshold Alerts
- **High Lag**: Consumer lag > 1000 records
- **Error Spike**: Error rate > 5%
- **Throughput Drop**: < 50% normal rate
- **Backpressure**: Queue depth > 80%

#### Anomaly Detection
- **ML Models**: Isolation forest untuk anomalies
- **Baseline**: Historical pattern analysis
- **Seasonality**: Time series decomposition
- **Correlation**: Cross-metric analysis

## Optimasi Performa

### Scaling Strategies

#### Horizontal Scaling
- **Auto Scaling**: Berdasarkan CPU/memori
- **Partitioning**: Data partitioning strategy
- **Parallelism**: Flink parallelism configuration
- **Sharding**: Kafka topic partitioning

#### Vertical Scaling
- **Resource Allocation**: CPU/memory optimization
- **Batch Sizing**: Optimal batch sizes
- **Buffer Sizes**: Network buffer tuning
- **JVM Tuning**: Garbage collection optimization

### Caching Strategies

#### In-Memory Caching
- **Redis**: Hot data caching
- **TTL**: Time-based expiration
- **Cache Aside**: Application-level caching
- **Write-through**: Automatic cache updates

#### Disk-based Caching
- **SSD Caching**: Frequently accessed data
- **Compression**: Data compression
- **Indexing**: Fast data access
- **Tiered Storage**: Hot/cold data separation

## Keamanan Data Streaming

### Encryption

#### In-Transit Encryption
- **TLS 1.3**: All communication encrypted
- **Certificate Rotation**: Otomatis setiap 90 hari
- **Mutual TLS**: Service-to-service auth
- **VPN**: Private connectivity

#### At-Rest Encryption
- **KMS**: AWS Key Management Service
- **Customer Keys**: Custom encryption keys
- **Envelope Encryption**: Efficient encryption
- **Key Rotation**: Annual key rotation

### Access Control

#### IAM Policies
- **Least Privilege**: Minimal access principle
- **Resource-based**: Bucket/topic policies
- **Role-based**: Service roles
- **Temporary Credentials**: STS tokens

#### Network Security
- **VPC Endpoints**: Private connectivity
- **Security Groups**: Network isolation
- **NACLs**: Subnet level control
- **WAF**: Application firewall

## Pipeline Data Streaming

### Real-time Pipeline

```
IoT Device → Kinesis Data Stream → Lambda → DynamoDB → API Gateway → Dashboard
     ↓
CloudWatch → SNS → Alert Manager → PagerDuty → Ops Team
```

### Batch Pipeline

```
S3 Landing → Glue Crawler → Glue Job → S3 Processed → Redshift → QuickSight
     ↓
EventBridge → Lambda → SNS → Email Notification → Stakeholders
```

### Hybrid Pipeline

```
Kafka → Flink → S3 → Athena → QuickSight
  ↓         ↓       ↓
Lambda → DynamoDB → API → Mobile App
```

## Pemecahan Masalah

### Isu Umum

#### High Latency
- **Check**: Network bandwidth
- **Solution**: Increase parallelism
- **Prevention**: Auto-scaling configuration

#### Data Loss
- **Check**: Checkpoint configuration
- **Solution**: Enable replication
- **Prevention**: Multi-AZ deployment

#### Backpressure
- **Check**: Consumer capacity
- **Solution**: Scale consumers
- **Prevention**: Monitor queue depth

### Debugging Tools

#### Logging
- **Structured Logs**: JSON format
- **Correlation IDs**: Request tracing
- **Log Levels**: Dynamic adjustment
- **Log Aggregation**: Centralized logging

#### Tracing
- **X-Ray**: AWS distributed tracing
- **Jaeger**: Open-source tracing
- **Custom Metrics**: Business metrics
- **Profiling**: Performance profiling

## Best Practices

### Development
- **Schema Registry**: Centralized schema management
- **Versioning**: Backward compatibility
- **Testing**: Unit, integration, performance
- **Documentation**: API documentation

### Operations
- **Monitoring**: Comprehensive observability
- **Alerting**: Proactive notifications
- **Backup**: Regular backups
- **DRP**: Disaster recovery plan

### Security
- **Encryption**: Default encryption
- **Access Control**: Regular audits
- **Compliance**: Industry standards
- **Training**: Security awareness

## Masa Depan Streaming Data

### Roadmap

#### Short Term (3 bulan)
- Machine Learning integration
- Enhanced monitoring
- Performance optimization
- Additional data sources

#### Medium Term (6 bulan)
- Edge computing
- Real-time analytics
- Predictive alerts
- Multi-region deployment

#### Long Term (12 bulan)
- AI/ML pipeline
- Blockchain integration
- 5G optimization
- Quantum computing exploration

### Teknologi Emerging

#### Stream Processing
- Apache Beam: Unified model
- Materialize: Streaming SQL
- RisingWave: Postgres-compatible
- Pathway: Python framework

#### Storage
- Delta Lake: ACID transactions
- Apache Iceberg: Table format
- Apache Hudi: Data lakehouse
- LakeFS: Git-like versioning

## Riwayat Revisi

| Versi | Tanggal | Perubahan | Author |
|-------|---------|-----------|--------|
| 1.0 | 25 Jun 2025 | Versi awal | Tim SMILE |
| 1.1 | 28 Jun 2025 | Tambah optimasi performa | Tim SMILE |
| 1.2 | 02 Jul 2025 | Update roadmap teknologi | Tim SMILE |
