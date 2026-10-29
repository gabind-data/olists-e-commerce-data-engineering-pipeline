WITH source AS (
    SELECT * 
    FROM {{source('olist_raw', 'olists_order_reviews')}}
),

renamed AS (
    SELECT
    review_id,
    order_id,

    cast(review_score AS INT) as review_score,
    initcap(review_comment_title) as review_comment_title,
    initcap(review_comment_message) as review_comment_message,
    try_to_timestamp_ntz(review_creation_date) as review_created_at,
    try_to_timestamp_ntz(review_answer_timestamp) as review_answered_at

    FROM source
) 

SELECT * FROM renamed