{{ config(
    materialized='table'
) }}

with base as (

    select
        movie_id,
        tag_id,
        round(relevance, 4) as relevance
    from {{ ref('stg_genome_scores') }}

),

classified as (

    select
        movie_id,
        tag_id,
        relevance,
        case
            when relevance >= 0.9 then 'very_high'
            when relevance >= 0.7 then 'high'
            when relevance >= 0.5 then 'medium'
            else 'low'
        end as relevance_bucket
    from base

),

enriched as (

    select
        c.movie_id,
        t.tag_name,
        c.relevance,
        c.relevance_bucket
    from classified c
    join {{ ref('dim_tags') }} t
      on c.tag_id = t.tag_id

)

select * from enriched
