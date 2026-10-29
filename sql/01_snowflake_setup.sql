-- On se met en admin pour créer l'infrastructure

USE ROLE ACCOUNTADMIN;

-- Création du DWH

CREATE WAREHOUSE IF NOT EXISTS TRANSFORM_DWH
    WITH WAREHOUSE_SIZE = 'XSMALL' -- Définir une taille petite du DWH
    AUTO_SUSPEND = 60 -- DWH se désactive après 60 secondes d'inactivité, pour pas cramer le budget
    AUTO_RESUME = TRUE -- Redémarre automatiquement le DWH lorsqu'une nouvelle requête nécessite des ressources de calculs
    INITIALLY_SUSPENDED = TRUE ; -- Après création le DWH reste suspendu pour ne pas consommmer des crédits de calculs, tant qu'il n'est pas démarré

-- Rôle dédié à dbt
CREATE ROLE IF NOT EXISTS TRANSFORM;
GRANT ROLE TRANSFORM TO ROLE SYSADMIN; -- On attribue le rôle TRANSFORM au rôle ADMIN
GRANT USAGE ON WAREHOUSE TRANSFORM_DWH TO ROLE TRANSFORM; -- Autorise l'usage du warehouse par TRANSFORM
GRANT OPERATE ON WAREHOUSE TRANSFORM_DWH TO ROLE TRANSFORM; -- Autorise le démarrage, l'arrêt ou la suspension des requêtes en cours sur le DWH

-- Création de la base de données
CREATE DATABASE IF NOT EXISTS OLISTS;
GRANT ALL ON DATABASE OLISTS TO ROLE TRANSFORM; -- On lie le rôle que l'on vient de créer à la database

-- Attribution du rôle à mon utilisateur
GRANT ROLE TRANSFORM TO USER "<YOUR_SNOWFLAKE_USERNAME>"; -- Remplacer par votre nom d'utilisateur Snowflake

CREATE STORAGE INTEGRATION IF NOT EXISTS OLISTS_GCS_INT
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'GCS'
    ENABLED = TRUE
    STORAGE_ALLOWED_LOCATIONS = ('gcs://<YOUR_GCS_BUCKET>/'); -- Remplacer par le nom de votre bucket GCS

-- Autoriser TRANSFORM à utiliser l'intégration
GRANT USAGE ON INTEGRATION OLISTS_GCS_INT
    TO ROLE TRANSFORM;

-- Récupérer l'identité Google utilisée par Snowflake
DESC INTEGRATION OLISTS_GCS_INT;

-- Espace de travail 
USE ROLE TRANSFORM;
USE WAREHOUSE TRANSFORM_DWH;
USE DATABASE OLISTS;

-- Création du schéma (=emplacement hébergeant nos tables)
CREATE SCHEMA IF NOT EXISTS RAW;
USE SCHEMA RAW;

CREATE OR REPLACE TABLE RAW.OLISTS_ORDERS (
    order_id VARCHAR,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp VARCHAR,
    order_approved_at VARCHAR,
    order_delivered_carrier_date VARCHAR,
    order_delivered_customer_date VARCHAR,
    order_estimated_delivery_date VARCHAR
);

CREATE OR REPLACE TABLE RAW.OLISTS_CUSTOMERS (
    customer_id VARCHAR,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix VARCHAR,
    customer_city VARCHAR,
    customer_state VARCHAR
);

CREATE OR REPLACE TABLE RAW.OLISTS_GEOLOCATION (
    geolocation_zip_code_prefix VARCHAR,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR,
    geolocation_state VARCHAR
);

CREATE OR REPLACE TABLE RAW.OLISTS_ORDER_ITEMS (
    order_id VARCHAR,
    order_item_id NUMBER,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date VARCHAR,
    price FLOAT,
    freight_value FLOAT
);

CREATE OR REPLACE TABLE RAW.OLISTS_ORDER_PAYMENTS (
    order_id VARCHAR,
    payment_sequential NUMBER,
    payment_type VARCHAR,
    payment_installments NUMBER,
    payment_value FLOAT
);

CREATE OR REPLACE TABLE RAW.OLISTS_ORDER_REVIEWS (
    review_id VARCHAR,
    order_id VARCHAR,
    review_score NUMBER,
    review_comment_title VARCHAR,
    review_comment_message VARCHAR,
    review_creation_date VARCHAR,
    review_answer_timestamp VARCHAR
);

CREATE OR REPLACE TABLE RAW.OLISTS_PRODUCTS (
    product_id VARCHAR,
    product_category_name VARCHAR,
    product_name_lenght NUMBER,
    product_description_lenght NUMBER,
    product_photos_qty NUMBER,
    product_weight_g NUMBER,
    product_lenght_cm NUMBER,
    product_height_cm NUMBER,
    product_width_cm NUMBER
);

CREATE OR REPLACE TABLE RAW.OLISTS_SELLERS (
    seller_id VARCHAR,
    seller_zip_code_prefix VARCHAR,
    seller_city VARCHAR,
    seller_state VARCHAR
);

-- Table seed dbt
CREATE OR REPLACE TABLE RAW.OLISTS_PRODUCT_CATEGORIES (
    product_category_name VARCHAR,
    product_category_name_english VARCHAR
);

-- Spécifier le format de fichier que l'on souhaite importer
CREATE OR REPLACE FILE FORMAT RAW.CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    NULL_IF = ('NULL','null')
    EMPTY_FIELD_AS_NULL = TRUE
    ENCODING = 'UTF8';

-- Stage pointant vers Google Cloud Storage
CREATE OR REPLACE STAGE RAW.OLISTS_GCS_STAGE
    URL = 'gcs://<YOUR_GCS_BUCKET>/' -- Remplacer par le nom de votre bucket GCS
    STORAGE_INTEGRATION = OLISTS_GCS_INT
    FILE_FORMAT = (
        FORMAT_NAME = 'OLISTS.RAW.CSV_FORMAT'
    );

