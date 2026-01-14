with source as (

    select *
    from {{ source('raw', 'RAW_GENOME_SCORES') }}

),

typed as (

    select
        movieid::int  as movie_id,
        tagid::int    as tag_id,
        relevance::float as relevance
    from source

)

select * from typed
