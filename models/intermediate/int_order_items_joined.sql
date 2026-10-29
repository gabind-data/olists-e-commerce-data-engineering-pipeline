WITH items AS (
    SELECT *
    FROM {{ref('stg_olists__order_items')}}
),

products AS (
    SELECT *
    FROM {{ref('stg_olists__products')}}
),

sellers AS (
    SELECT *
    FROM {{ref('stg_olists__sellers')}}
),

categories_translated AS (
    SELECT *
    FROM {{ref('product_category_name_translation')}}
),

JOINED AS (
    SELECT
        items.order_id,
        items.product_id,
        items.order_item_id,
        items.seller_id,
        items.shipping_limit_at,
        items.price,
        items.freight_value,
        items.total_item_value,

        coalesce(categories_translated.product_category_name_english, products.category_name) AS category_name,
        products.weight_g,

        sellers.seller_city,
        sellers.seller_state
    
    FROM items
    LEFT JOIN products
        ON items.product_id = products.product_id
    LEFT JOIN categories_translated
        ON products.category_name = categories_translated.product_category_name
    LEFT JOIN sellers
        ON items.seller_id = sellers.seller_id

)

SELECT * FROM JOINED