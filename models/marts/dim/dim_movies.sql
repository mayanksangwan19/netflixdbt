{{ config(
    materialized='table'
) }}

with movies as (

    select
        movie_id,
        title
    from {{ ref('stg_movies') }}

)

select * from movies
