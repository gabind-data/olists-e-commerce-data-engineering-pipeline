
# Olist Data Engineering Pipeline

## Project Overview

This project demonstrates the implementation of an end-to-end
data engineering pipeline using Google Cloud Storage, Snowflake,
and dbt.

The project uses the Brazilian Olist e-commerce dataset,
containing information about orders, customers, products,
payments, sellers, and reviews.

The objective is to build a structured data warehouse,
transform raw data into analytical models, and implement
data quality checks.

## Dataset

This project uses the **Brazilian E-Commerce Public Dataset by Olist**,
containing approximately 100,000 orders from Brazilian marketplaces
between 2016 and 2018.

**Original source:**
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

**Data provider:** Olist

**License:** CC BY-NC-SA 4.0

**Tutorial used:**
https://www.youtube.com/watch?v=NT9WII_rHdE&list=LL&index=72

### Downloading the Data

The original CSV files are not included in this repository.

To reproduce the pipeline:

1. Download the dataset from Kaggle.
2. Extract the CSV files.
3. Create a Google Cloud Storage bucket.
4. Upload the CSV files to the bucket.
5. Configure the Snowflake storage integration.
6. Execute the SQL scripts in the `sql/` directory.
7. Run the dbt transformations and tests.

The category translation file is loaded separately using `dbt seed`.
 
## Tech Stack

- Google Cloud Storage (GCS) — Cloud object storage
- Snowflake — Cloud data warehouse
- dbt Core — Data transformation and testing
- SQL — Data modeling and transformation
- Python — Local development environment
- Git & GitHub — Version control

## Data Architecture

The pipeline follows a layered architecture:

CSV Files
    |
    v
Google Cloud Storage
    |
    v
Snowflake - RAW
    |
    v
dbt - STAGING
    |
    v
dbt - INTERMEDIATE
    |
    v
dbt - MARTS

### RAW Layer

Raw CSV files are stored in Google Cloud Storage and
loaded into Snowflake using external stages and COPY INTO.

### STAGING Layer

Standardizes raw datasets:

- Column renaming
- Data type conversions
- Data cleaning
- Initial data preparation

### INTERMEDIATE Layer

Performs business transformations:

- Payment aggregation
- Order enrichment
- Product, order item, and seller joins

### MARTS Layer

Creates analytical tables:

**Dimensions:**
- dim_customers
- dim_products
- dim_sellers

**Facts:**
- fct_orders
- fct_orders_items

## Data Quality

Data quality is validated using dbt tests:

- Unique key validation
- Not-null constraints
- Referential integrity checks
- Accepted values and ranges
- Custom business rules

Run tests with:

    dbt test

## Snapshots

The project includes a dbt snapshot configuration
to track changes in order status.

Snapshots use the check strategy to detect changes
in the `order_status` column.

Run snapshots with:

    dbt snapshot

## Getting Started

### Prerequisites

- Python
- dbt Core with Snowflake adapter
- Snowflake account
- Google Cloud Storage bucket
- Appropriate Snowflake and GCS permissions

### Installation

Install the required dbt dependencies:

    dbt deps

Configure your local Snowflake connection
in `~/.dbt/profiles.yml`.

Load the raw data into Snowflake before running
the transformation models.

### Running the Project

Check the Snowflake connection:

    dbt debug

Load reference data:

    dbt seed

Execute transformation models:

    dbt run

Run data quality tests:

    dbt test

Generate documentation:

    dbt docs generate

## Future Improvements

- Automate data ingestion using Python
- Implement pipeline orchestration
- Add monitoring and logging
- Introduce CI/CD workflows

## Author

Personal Data Engineering portfolio project.

## dbt Model Lineage

![dbt_DAG](olists_analytics/docs/images/olists_dag.png)
