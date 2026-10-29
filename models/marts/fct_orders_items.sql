{{
    config(
        materialized='incremental',
        unique_key='order_item_pk',
        on_schema_change='append_new_columns'
    )
}}

WITH items AS (
    SELECT *
    FROM {{ref('int_order_items_joined')}}
),

orders AS (
    SELECT 
        order_id,
        customer_unique_id,
        order_status,
        ordered_at, 
    FROM {{ref('int_orders_enriched')}}
),

FINAL AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['items.order_id', 'items.order_item_id']) }} AS order_item_pk,
        items.order_id,
        items.order_item_id,
        items.product_id,
        items.seller_id,
        orders.customer_unique_id,
        orders.order_status,
        items.category_name,
        orders.ordered_at,
        items.price,
        items.freight_value,
        items.total_item_value,
    FROM items 
    LEFT JOIN orders 
        ON items.order_id = orders.order_id
)

SELECT * FROM FINAL

{% if is_incremental() %}

    WHERE ordered_at > (SELECT MAX(ordered_at) FROM {{ this }})

{% endif %}