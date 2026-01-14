with source as (

    select *
    from {{ source('raw', 'RAW_MOVIES') }}

),

renamed as (

    select
        movieid::int      as movie_id,
        title::string     as title,
        genres::string    as genres_raw
    from source

)

select * from renamed
