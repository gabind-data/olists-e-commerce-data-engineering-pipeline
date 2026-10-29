WITH product AS (
    SELECT *
    FROM {{ ref('stg_olists__products') }}
),

categories_translated AS (
    SELECT *
    FROM {{ ref('product_category_name_translation') }}
),

item_stats AS (
    SELECT
        product_id,
        COUNT(*) AS nb_times_solded,
        AVG(price) AS avg_price,
        SUM(price) AS total_revenue,
    FROM {{ref('int_order_items_joined')}}
    GROUP BY 1
),

FINAL AS (
    SELECT
        p.product_id,
        COALESCE(c.product_category_name_english, p.category_name) AS category_name_english,
        p.category_name,
        p.weight_g,
        p.length_cm,
        p.height_cm,
        p.width_cm,
        s.nb_times_solded,
        s.avg_price,
        s.total_revenue
    FROM product p
    LEFT JOIN categories_translated c
        ON p.category_name = c.product_category_name
    LEFT JOIN item_stats s
        ON p.product_id = s.product_id
)

SELECT * FROM FINAL