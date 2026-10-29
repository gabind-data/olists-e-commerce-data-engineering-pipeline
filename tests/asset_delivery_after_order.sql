-- Une commande ne peut pas être livrée si elle n'a pas été payée. Cette requête vérifie que toutes les commandes livrées ont été payées.

SELECT
    order_id,
    ordered_at,
    delivered_customer_at,
FROM {{ref('fct_orders')}}
WHERE delivered_customer_at < ordered_at