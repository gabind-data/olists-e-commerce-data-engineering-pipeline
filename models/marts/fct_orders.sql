WITH orders AS (
    SELECT *
    FROM {{ref('int_orders_enriched')}}
),

FINAL AS (
    SELECT
        order_id,
        customer_unique_id,
        order_status,
        payment_type,
        customer_state,
        ordered_at,
        delivered_customer_at,
        estimated_delivery_at,
        total_payment_value,
        max_installments,
        delivery_days,
        delivery_vs_estimated_days,
        review_score,
        CASE
            WHEN delivery_vs_estimated_days <= 0 THEN true ELSE false END AS is_on_time,
        CASE
            WHEN order_status = 'delivered' THEN true ELSE false END AS is_delivered

    FROM orders
)

SELECT * FROM FINAL