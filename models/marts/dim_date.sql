WITH DATE_SPINE AS
(
  {{- dbt_utils.date_spine(
    datepart="day",
    start_date="PARSE_DATE('%m/%d/%Y', '01/01/2008')",
    end_date="PARSE_DATE('%m/%d/%Y', '01/01/2022')"
    )
  -}}
)
SELECT
CAST(DATE_DAY AS DATE) AS DATE_KEY
FROM DATE_SPINE


