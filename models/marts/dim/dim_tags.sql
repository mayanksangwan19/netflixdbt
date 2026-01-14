{{ config(
    materialized='table'
) }}

with tags as (

    select
        tag_id,
        tag_name
    from {{ ref('stg_genome_tags') }}

)

select * from tags
