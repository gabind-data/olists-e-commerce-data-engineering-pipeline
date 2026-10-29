WITH source AS (
    SELECT * 
    FROM {{source('olist_raw', 'olists_orders')}}
),

renamed AS (
    SELECT
    order_id,
    customer_id,
    order_status,

    try_to_timestamp_ntz(order_purchase_timestamp) as ordered_at,
    try_to_timestamp_ntz(order_approved_at) as approved_at,
    try_to_timestamp_ntz(order_delivered_carrier_date) as delivered_carrier_at,
    try_to_timestamp_ntz(order_delivered_customer_date) as delivered_customer_at,
    try_to_timestamp_ntz(order_estimated_delivery_date) as estimated_delivery_at

    FROM source
) 

SELECT * FROM renamed