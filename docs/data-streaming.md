# UNDPINDO - SMILE Platform Development and Upgrades : Data Streaming Mechanism

UNDPINDO - SMILE Platform Development and Upgrades : Data Streaming Mechanism  

1.  [Home](../index.html)
2.  [DPG Tasks Tracker](dpg/tasks-tracker.md)
3.  [Deployment Guide](deployment-guide.md)
4.  [Technical Overview](technical-overview.md)
5.  [Cloud Infrastructure](cloud-infrastructure.md)
8.  [SMILE Technical Overview Document](./SMILE-Technical-Overview-Document_5805277215.html)

# UNDPINDO - SMILE Platform Development and Upgrades : Data Streaming Mechanism

This article was last updated on 26 Jun 2025

/\*<!\[CDATA\[\*/ div.rbtoc1766968433012 {padding: 0px;} div.rbtoc1766968433012 ul {list-style: default;margin-left: 0px;} div.rbtoc1766968433012 li {margin-left: 0px;padding-left: 0px;} /\*\]\]>\*/

-   [About](#DataStreamingMechanism-About)
-   [Technology Stack](#DataStreamingMechanism-TechnologyStack)
-   [Step-to-step Guide](#DataStreamingMechanism-Step-to-stepGuide)
    -   [Using Kubernetes](#DataStreamingMechanism-UsingKubernetes)
-   [Data Pipeline](#DataStreamingMechanism-DataPipeline)
    -   [Data Source (MySQL)](#DataStreamingMechanism-DataSource(MySQL))
    -   [Data Extraction (Kafka)](#DataStreamingMechanism-DataExtraction(Kafka))
    -   [Data Transformation (RisingWave)](#DataStreamingMechanism-DataTransformation(RisingWave))
    -   [Data Warehouse (ClickHouse)](#DataStreamingMechanism-DataWarehouse(ClickHouse))
-   [Performance Overview](#DataStreamingMechanism-PerformanceOverview)
-   [Revision History](#DataStreamingMechanism-RevisionHistory)

# About

---

This document provides technical implementation guidance for building a real-time data streaming pipeline that integrates MySQL, Debezium, Kafka, RisingWave, and ClickHouse to enable continuous data flow from OLTP to OLAP systems within the SMILE platform, particularly in the Dashboard and Report service. The document outlines best practices, configuration approaches, and operational considerations required to ensure a robust, scalable, and maintainable streaming architecture. It aims to serve as a reference for both initial setup and ongoing maintenance of the pipeline in containerised environments.

# Technology Stack

---

-   **MySQL Database:** Acts as the source OLTP database. Must be configured to allow CDC (binlog enabled);
    
-   **Kafka Connect containing Debezium:** Captures real-time data changes (insert, update, delete) from MySQL. Streams changed data into specified Kafka topics;
    
-   **Kafka:** Used as the message broker to receive and forward change events;
    
-   **Risingwave:** Processes and transforms the streamed data. Reads data from Kafka topics, applies transformations, and outputs to different Kafka topics;
    
-   **Clickhouse Database:** Serves as the target OLAP database. Requires table definitions that are compatible with Kafka message formats.
    

# Step-to-step Guide

---

To implement the data pipeline configuration for data streaming for SMILE, follow these steps:

## Using Kubernetes

1.  Run MySQL, Clickhouse, Debezium (Kafka Connect), Kafka, and Risingwave with Kubernetes operators. For Kafka Connect and Kafka, you can use the Strimzi operator;
    
2.  Create Debezium connector configuration in YAML. It is recommended to create one connection for many tables rather than one connection per table, as it requires much less resource;
    
3.  Apply the configuration to Kubernetes;
    
4.  Create Risingwave tables to read data from Kafka topics, transform them, and store them in another Kafka topics;
    
5.  Create ClickHouse tables to capture data from Kafka topics. The ClickHouse data type must be compatible with the data stored in Kafka;
    
6.  Create ClickHouse Sink Connector connectors to stream data from Kafka topics into Clickhouse Tables and apply them to Kubernetes;
    
7.  Create a materialised view to process captured data in ClickHouse if needed;
    
8.  Create ClickHouse tables to capture data from Kafka topics. The ClickHouse data type must be compatible with the data stored in Kafka.
    

# Data Pipeline

---

![image-20250619-043130.png](../../assets/attachments/5840994486/5842141266.png?width=1280)

## Data Source (MySQL)

-   **Source Database**:  
    A transactional MySQL database serves as the source system. Tables are monitored for changes using CDC.
    
-   **Change Data Capture (CDC)**:  
    Debezium is used to monitor and capture row-level changes (INSERT, UPDATE, DELETE) from MySQL in real time.
    
-   **Configuration**:
    
    -   Debezium connector: `io.debezium.connector.mysql.MySqlConnector`
        
    -   Key configurations:
        
        -   `database.hostname`, `database.include.list`, `table.include.list`
            
        -   `snapshot.mode`: (e.g., `initial` or `when_needed`)
            

## Data Extraction (Kafka)

-   **Topic Design**:  
    Partitioning strategy often relies on the table's primary key or unique identifier for balanced distribution.
    
-   **Message Format**:  
    Data is serialised in JSON format. A **Schema Registry** is used to manage schema evolution.
    
-   **Retention & Replay**:  
    Kafka topics have configured retention settings (e.g., time-based or size-based). Consumer groups can manage reprocessing by resetting offsets, enabling historical replay and backfill.
    

## Data Transformation (RisingWave)

After data enters Kafka, the pipeline checks whether transformation is needed:

-   If **no transformation** is required:  
    Kafka topics are **streamed directly** to ClickHouse for ingestion.
    
-   If **transformation is needed**:  
    The Kafka topic is ingested into **RisingWave**, which acts as a real-time SQL stream processing system.
    
-   **Transformation Logic**:  
    RisingWave allows users to write **SQL-based transformation queries** over incoming Kafka topics. These queries can be implemented:
    
    -   Field renaming or mapping
        
    -   Data enrichment (e.g., joins with reference data)
        
    -   Business rules (e.g., currency conversion, aggregation)
        
    -   Filtering or conditional routing
        
-   **Config & Workflows**:  
    Transformations are defined in RisingWave using SQL statements that create **materialised views**. These views can be published as new Kafka topics (transformed topics).
    
-   **Performance Considerations**:  
    RisingWave processes streams with low latency and can be tuned via:
    
    -   Batch window settings
        
    -   Parallelism for stream operators
        
    -   Backpressure and resource utilisation
        

## Data Warehouse (ClickHouse)

-   **Destination DB**:  
    The final storage layer is ClickHouse, a high-performance OLAP database. Kafka topics (either raw or transformed) are ingested into specific ClickHouse tables, which are **not a 1:1 copy** of MySQL tables — they are optimised for analytical queries.
    
-   **Write Strategy**:
    
    -   Direct Kafka Topic and Transformed Kafka Topic are stored on Clickhouse;
        
    -   Table engine in ClickHouse using `ReplicatedReplacingMergeTree`
        

# Performance Overview

---

-   **Performance Benchmark:**
    
    -   Sink Throughput Debezium (MySQL->Kafka): Rows per second and bytes per second inserted from MySQL to Kafka;
        
    -   Sink Throughput Clickhouse Sink (Kafka->Clickhouse): Rows per second and bytes per second processed from Kafka to Clickhouse;
        
    -   Read/Write Throughput via Risingwave: Rows per second processed on the sink pipeline via Risingwave.
        
-   **Bottlenecks:**
    
    -   Storage Kafka during a one-time load;
        
    -   Risingwave resource usage during one-time load due to many JOINs;
        
    -   Need one-time loading of the whole database every time the Sink Connector configuration is modified;
        
    -   Error memory limit while having many concurrent users accessing a heavily loaded dashboard.
        
-   **Scaling Strategies:**
    
    -   Horizontal Pod Autoscale at Risingwave;
        
    -   Vertical Scaling of Clickhouse & Kafka Connect (inc. Debezium).
        

# Revision History

---

**Internal Use Only. This content is not intended for publication in the live environment.**

| Date | Change description | Author | Status |
| --- | --- | --- | --- |
| 26 Jun 2025 | Proofread content. | Lead TW | Done |
| 25 Jun 2025 | Done. Ready for review | TW | Done |
| 19 Jun 2025 | Updated on some sections and all section is reviewed by Data Team except for Performance Overview | TW | Done |
| 18 Jun 2025 | Initial document. | TW | Done |

## Attachments:

![](../../assets/images/icons/bullet_blue.gif) [image-20250619-043130.png](../../assets/attachments/5840994486/5842141266.png) (image/png)  

Document generated by Confluence on Dec 29, 2025 00:33

[Atlassian](http://www.atlassian.com/)