# Cross-Platform Ads Performance Analysis

This project includes an SQL query designed to analyze and compare daily ad performance across multiple advertising platforms (Facebook and Google). The query aggregates key metrics like total cost, clicks, impressions, and conversion rates for each platform.

## Query Overview

The query performs the following actions:
1. **Combines Data from Facebook and Google Ads**: Uses a `UNION ALL` statement to create a unified dataset from the `facebook_ads_basic_daily` and `google_ads_basic_daily` tables.
2. **Aggregates Key Metrics**: Calculates total spend, clicks, impressions, and conversion rates for each platform on a daily basis.

## Query Structure

### Common Table Expression (CTE): `adsnew`
The CTE `adsnew` combines daily ad performance data from two sources:
- **Facebook Ads**: Data is pulled from `facebook_ads_basic_daily` with each entry labeled as `'Facebook_Ads'`.
- **Google Ads**: Data is pulled from `google_ads_basic_daily` with each entry labeled as `'Google_Ads'`.

### Main Query
The main query performs the following calculations on the combined dataset:
- **Total Cost**: Aggregates ad spend for each platform and date.
- **Total Clicks**: Summarizes total clicks per day.
- **Total Impressions**: Summarizes total impressions per day.
- **Conversion Rate**: Calculates the click-through rate as `(clicks * 100) / impressions`.

The query filters out records with zero impressions to ensure valid conversion rate calculations.

## SQL Query

```sql
WITH adsnew AS (
    SELECT 
        ad_date,
        'Facebook_Ads' AS media_source,
        spend,
        clicks,
        impressions,
        value,
        reach,
        leads
    FROM 
        facebook_ads_basic_daily AS fabd

    UNION ALL

    SELECT 
        ad_date,
        'Google_Ads' AS media_source,
        spend,
        clicks,
        impressions,
        value,
        reach,
        leads
    FROM 
        google_ads_basic_daily AS gabd
)

SELECT
    ad_date,
    media_source,
    SUM(spend) AS total_cost,
    SUM(clicks) AS total_clicks,
    SUM(impressions) AS total_impressions,
    SUM(clicks * 100 / impressions) AS conversion_rate
FROM 
    adsnew
WHERE 
    impressions <> 0
GROUP BY 
    ad_date, 
    media_source;
```
## Explanation of Key Metrics

- **Total Cost**: Total ad spend per platform for each date.
- **Total Clicks**: Total number of clicks recorded per platform and date.
- **Total Impressions**: Total impressions shown per platform and date.
- **Conversion Rate**: Percentage of impressions that resulted in clicks, calculated as `(clicks * 100) / impressions`.

## Usage

- Run the query in your SQL environment to retrieve daily performance metrics for Facebook and Google Ads.
- Use the output to compare ad spend efficiency, click engagement, and conversion rates across platforms.
- Modify the `WHERE` clause to apply additional filters or adjust the `GROUP BY` clause for different aggregations.

## Example Output

| ad_date     | media_source | total_cost | total_clicks | total_impressions | conversion_rate |
|-------------|--------------|------------|--------------|-------------------|-----------------|
| 2023-11-01  | Facebook_Ads | 1500       | 300          | 30000            | 1.0             |
| 2023-11-01  | Google_Ads   | 1200       | 240          | 28000            | 0.86            |

This output allows a day-by-day comparison of ad performance metrics across Facebook and Google Ads, helping advertisers evaluate cost efficiency and engagement levels on each platform.

## Author & Contact Information

This analysis was developed by a data analyst with expertise in SQL and cross-platform ad performance analytics.

For further questions:
- **GitHub Issues**: Open an issue in the repository for questions or feedback.
- **Email**: Reach out via email at [dogankaraoglu025@gmail.com](mailto:dogankaraoglu025@gmail.com).

## Additional Resources

For more SQL-based data analysis projects, visit the [CTE and Union](https://github.com/Necodk/Data-Analysis-Projects/blob/main/SQL/Sql_Cte_and_Union.sql).
