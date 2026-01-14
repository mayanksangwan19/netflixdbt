with source as (

    select *
    from {{ source('raw', 'RAW_TAGS') }}

),

typed as (

    select
        userid::int              as user_id,
        movieid::int             as movie_id,
        tag::string              as tag,
        to_timestamp(event_time) as tagged_at
    from source

)

select * from typed
