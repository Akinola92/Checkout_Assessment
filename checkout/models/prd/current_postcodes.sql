{{ config(materialized='table') }}

with recent_postcode as
  (SELECT MAX(Users_DT), id, postcode FROM {{ ref('stg_users') }}
    GROUP BY id, postcode),

final as (SELECT u.*, p.url, p.[PageViews_DT], 1 as [PageView_Count]
          FROM recent_postcode u
          INNER JOIN {{ ref('stg_pageviews') }} p on u.id = p.id)


SELECT * FROM final
