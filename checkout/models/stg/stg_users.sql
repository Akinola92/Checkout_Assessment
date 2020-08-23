{{ config(materialized='incremental') }}

select *, cast(getdate() as date) as [Users_DT]
FROM {{ source('extracts', 'users_extract') }}

{% if is_incremental() %}
  and concat(id, postcode) NOT IN ( SELECT  concat(id, postcode)
                                  FROM {{ ref('current_postcodes') }})
{% endif %}
