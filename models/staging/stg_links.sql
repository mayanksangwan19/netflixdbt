with source as (

    select *
    from {{ source('raw', 'RAW_LINKS') }}

),

renamed as (

    select
        movieid::int as movie_id,
        imdbid::int  as imdb_id,
        tmdbid::int  as tmdb_id
    from source

)

select * from renamed
