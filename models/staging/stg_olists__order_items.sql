WITH source AS (
    SELECT * 
    FROM {{source('olist_raw', 'olists_order_items')}}
),

renamed AS (
    SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,

    try_to_timestamp_ntz(shipping_limit_date) as shipping_limit_at,
    price,
    freight_value,
    price + freight_value as total_item_value

    FROM source
) 

SELECT * FROM renamed