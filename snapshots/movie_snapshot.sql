{% snapshot movies_snapshot %}

{{
    config(
        target_schema = 'snapshots',
        unique_key = 'movie_id',
        strategy = 'check',
        check_cols = ['title', 'genres_raw']
    )
}}

select
    movie_id,
    title,
    genres_raw
from {{ ref('stg_movies') }}

{% endsnapshot %}
