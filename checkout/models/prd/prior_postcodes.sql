{{ config(materialized='table') }}

select u.*, p.url, p.[PageViews_DT], 1 as [PageView_Count]
FROM {{ ref('stg_users') }} u
INNER JOIN {{ ref('stg_pageviews') }} p
      on u.id = p.user_id AND u.[Users_DT] = CAST(p.[PageViews_DT] as date)
