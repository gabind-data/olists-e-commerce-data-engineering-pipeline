WITH source AS (
    SELECT * 
    FROM {{source('olist_raw', 'olists_customers')}}
),

renamed AS (
    SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix AS zip_code_prefix,
    initcap(customer_city) AS customer_city,
    upper(customer_state) AS customer_state

    FROM source
) 

SELECT * FROM renamed