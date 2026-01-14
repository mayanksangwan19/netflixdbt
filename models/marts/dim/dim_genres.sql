{{ config(
    materialized='table'
) }}
with genres as (

    select distinct
        genre
    from {{ ref('int_movie_genres') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['genre']) }} as genre_sk,
        genre
    from genres

)

select * from final
