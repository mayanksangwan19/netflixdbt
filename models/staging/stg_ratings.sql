{{ config(
    materialized = 'incremental',
    unique_key = 'rating_sk'
) }}

with source as (

    select *
    from {{ source('raw', 'RAW_RATINGS') }}

),

typed as (

    select
        userid::int                    as user_id,
        movieid::int                   as movie_id,
        rating::float                  as rating,
        to_timestamp(timestamp)        as rated_at
    from source

),

final as (

    select
        *,
        {{ dbt_utils.generate_surrogate_key(
            ['user_id','movie_id','rated_at']
        ) }} as rating_sk
    from typed

)

select * from final

{% if is_incremental() %}
where rated_at > (select max(rated_at) from {{ this }})
{% endif %}
