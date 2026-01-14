with movies as (

    select
        movie_id,
        genres_raw
    from {{ ref('stg_movies') }}

),

exploded as (

    select
        movie_id,
        trim(value) as genre
    from movies,
         lateral split_to_table(genres_raw, '|')

)

select * from exploded
