{{ config(materialized='incremental', unique_key='rating_sk') }}

with base as (

    select
        user_id,
        movie_id,
        rating,
        rated_at
    from {{ ref('stg_ratings') }}
    where rating between 0.5 and 5.0

),

deduped as (

    select
        *,
        row_number() over (
            partition by user_id, movie_id
            order by rated_at desc
        ) as rn
    from base

),

latest_rating as (

    select
        user_id,
        movie_id,
        rating,
        rated_at
    from deduped
    where rn = 1

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(
            ['user_id','movie_id','rated_at']
        ) }} as rating_sk,
        user_id,
        movie_id,
        round(rating, 2)        as rating,
        rated_at,
        date(rated_at)         as rating_date,
        year(rated_at)         as rating_year,
        month(rated_at)        as rating_month
    from latest_rating

)

select * from final

{% if is_incremental() %}
where rated_at > (select max(rated_at) from {{ this }})
{% endif %}
