{% snapshot orders_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='check',
        check_cols=['order_status']
    )
}}

SELECT
    order_id,
    order_status,
    customer_id,
    ordered_at,
    approved_at,
    delivered_customer_at,
FROM {{ref('stg_olists__orders')}}

{% endsnapshot %}