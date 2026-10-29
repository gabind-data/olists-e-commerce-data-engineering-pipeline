WITH payments AS (
    SELECT *
    FROM {{ref('stg_olists__order_payments')}}
),

aggregated AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value,
        COUNT(*) AS nb_payments_lines,
        MAX(payment_installments) AS max_installments,
        MAX(payment_type) AS payment_type_sample

    FROM payments
    GROUP BY 1
)
SELECT * FROM aggregated
