# Checkout_Assessment

The Data warehouse is formed of the schemas following and tables:

1. Ext (extracts)
  ⁃ Users_extract
    • “Id” - Datatype = int
    • “Postcode” - Datatype = nvarchar(6)
  ⁃ Pageviews_extract
    • “User_Id” - Datatype = int
    • “URL” - Datatype = nvarchar(255)

2. Stg (Staging)
  ⁃ Stg_users
    • “Id” - Datatype = int
    • “Postcode” - Datatype = nvarchar(6)
    • “User_DT” - Datatype = date
  ⁃ Stg_pageviews
    • “User_Id” - Datatype = int
    • “URL” - Datatype = nvarchar(255)
    • “Pageview_DT” - Datatype = datetime

3. Prd (Production)
    ⁃ Current_postcodes
    • “Id” - Datatype = int
    • “Postcode” - Datatype = nvarchar(6)
    • “URL” - Datatype = nvarchar(255)
    • “User_DT” - Datatype = date
    • “Pageview_DT” - Datatype = datetime
    • “Pageview_Count” - Datatype = int
  ⁃ Historic_postcodes
    • “Id” - Datatype = int
    • “Postcode” - Datatype = nvarchar(6)
    • “URL” - Datatype = nvarchar(255)
    • “User_DT” - Datatype = date
    • “Pageview_DT” - Datatype = datetime
    • “Pageview_Count” - Datatype = int



The transformation pipeline begins with 2 parts:
1. Incrementally Consumes data from the users_extract data table,comparing it against existing data in the stg_users table and adding new or updated records. 
   This is scheduled to run once a day at around 0100. Upon the loading of data into staging table, a date stamp/column will be inserted into the table to highlight when this new record was added.
2. Fully consuming all data from the table pageviews_extract on an hourly basis at around half past every hour (0530, 0630, 0730 etc.). 
   Similarly to the users staging table, a datetime stamp/column will be inserted to highlight when this new record was added to the table.


The next step in the transformation process consists of the joining of the tables. This is done twice, resulting in 2 different denormalized tables/models.
1. Detailing a user’s most recent postcode
2. Showing the postcode a user was at at the time the page view was made (tables joined by user_id and dates)
   Also in this step, a count of 1 is assigned to each of the urls, this will be used to created total counts of pageviews.

The resulting denormalized tables are then ready to be consumed by a BI tool and display the Count of pageviews per postcode by dates. 
These tables will also be refreshed hourly because the source data table, “pageviews_extract” is refreshed this frequently.
