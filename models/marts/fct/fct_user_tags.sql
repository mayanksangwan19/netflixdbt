{{ config(materialized='incremental', unique_key='user_tag_sk') }}

with base as (

    select
        user_id,
        movie_id,
        lower(trim(tag)) as tag,
        tagged_at
    from {{ ref('stg_tags') }}
    where tag is not null

),

deduped as (

    select
        *,
        row_number() over (
            partition by user_id, movie_id, tag
            order by tagged_at desc
        ) as rn
    from base

),

filtered as (

    select
        user_id,
        movie_id,
        tag,
        tagged_at
    from deduped
    where rn = 1

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(
            ['user_id','movie_id','tag','tagged_at']
        ) }} as user_tag_sk,
        user_id,
        movie_id,
        tag,
        tagged_at
    from filtered

)

select * from final

{% if is_incremental() %}
where tagged_at > (select max(tagged_at) from {{ this }})
{% endif %}
