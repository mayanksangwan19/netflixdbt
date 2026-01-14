{{ config(
    materialized='table')}}

with users as (

    select distinct
        user_id
    from {{ ref('stg_ratings') }}

)

select * from users
