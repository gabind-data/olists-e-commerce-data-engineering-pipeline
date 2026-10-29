WITH source AS (
    SELECT * 
    FROM {{source('olist_raw', 'olists_products')}}
),

renamed AS (
    SELECT
    product_id,
    product_category_name AS category_name,
    cast(product_name_lenght AS int) AS name_length,
    cast(product_description_lenght AS int) AS description_length,
    cast(product_photos_qty AS int) AS photos_qty,
    cast(product_weight_g AS int) AS weight_g,
    cast(product_lenght_cm AS int) AS length_cm,
    cast(product_height_cm AS int) AS height_cm,
    cast(product_width_cm AS int) AS width_cm
    
    FROM source
) 

SELECT * FROM renamed