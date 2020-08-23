{{ config(materialized='table') }}

select *, getdate() as [PageViews_DT]
FROM {{ source('extracts', 'pageviews_extract') }}
