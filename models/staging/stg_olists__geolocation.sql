WITH source AS (
    SELECT * 
    FROM {{source('olist_raw', 'olists_geolocation')}}
),

renamed AS (
    SELECT
    geolocation_zip_code_prefix AS zip_code_prefix,
    avg(geolocation_lat) AS lat,
    avg(geolocation_lng) AS lng,
    any_value(geolocation_city) AS geolocation_city,
    any_value(geolocation_state) AS geolocation_state

    FROM source
    GROUP BY 1
) 

SELECT * FROM renamed