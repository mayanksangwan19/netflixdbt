with source as (

    select *
    from {{ source('raw', 'RAW_GENOME_TAGS') }}

),

renamed as (

    select
        tagid::int    as tag_id,
        tag::string   as tag_name
    from source

)

select * from renamed
