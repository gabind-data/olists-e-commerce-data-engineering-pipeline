WITH source AS (
    SELECT * 
    FROM {{source('olist_raw', 'olists_order_payments')}}
),

renamed AS (
    SELECT
    order_id,

    cast(payment_sequential AS INT) as payment_sequential,
    upper(payment_type) as payment_type,
    cast(payment_installments AS INT) as payment_installments,
    payment_value

    FROM source
) 

SELECT * FROM renamed