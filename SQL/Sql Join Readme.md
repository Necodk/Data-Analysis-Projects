# Cross-Platform Ads and Facebook ROMI Analysis

This project provides SQL queries to analyze and aggregate Facebook and Google ads data, offering insights into campaign performance across multiple metrics. The queries combine data from multiple tables, calculate key advertising metrics, and compute ROMI (Return on Marketing Investment) for Facebook ad sets.

## Query Overview

### CTE Definitions for Cross-Platform Data Combination
The first part of this query defines two Common Table Expressions (CTEs):
1. **newcte**: Retrieves Facebook ads data, joining additional campaign and ad set details.
2. **newcte2**: Retrieves Google ads data in a similar structure to facilitate unified analysis.

The CTEs combine essential metrics such as `spend`, `clicks`, `impressions`, `reach`, `leads`, `value`, along with `campaign_name` and `adset_name` from Facebook and Google data tables. This setup enables cross-platform performance comparisons.

### SQL Code

```sql
-- Facebook ve Google reklam verilerini birleştiren CTE tanımlamaları
WITH newcte AS (
    SELECT
        fabd.ad_date,
        'Facebook_Ads' AS media_source,
        fabd.spend,
        fabd.clicks,
        fabd.impressions,
        fabd.reach,
        fabd.leads,
        fabd.value,
        fc.campaign_name,
        fa.adset_name
    FROM
        facebook_ads_basic_daily AS fabd
    LEFT JOIN
        facebook_campaign AS fc
    ON
        fabd.campaign_id = fc.campaign_id
    LEFT JOIN
        facebook_adset AS fa
    ON
        fabd.adset_id = fa.adset_id
),
newcte2 AS (
    SELECT
        ad_date,
        'Google_Ads' AS media_source,
        spend,
        clicks,
        impressions,
        reach,
        leads,
        value,
        campaign_name,
        adset_name
    FROM
        google_ads_basic_daily AS gabd
)

-- Birleştirilen verilerin toplu özeti
SELECT
    ad_date,
    campaign_name,
    adset_name,
    media_source,
    SUM(value) AS total_revenue,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(clicks * 100 / impressions) AS conversion_rate
FROM (
    SELECT * FROM newcte
    UNION ALL
    SELECT * FROM newcte2
) AS task4
WHERE
    impressions <> 0
GROUP BY
    ad_date,
    media_source,
    campaign_name,
    adset_name;
```

## ROMI Calculation for Facebook Ads
The second part of the query calculates the Return on Marketing Investment (ROMI) for Facebook ad sets, focusing on high-spend ad sets. This query joins facebook_ads_basic_daily with additional campaign and ad set details, then calculates:

Total Spend: Total ad spend for each ad set.
ROMI: Computed as (value - spend) * 100 / spend, representing the profitability percentage relative to ad spend.
The query filters ad sets with spend over $500,000 and sorts the results by ROMI in descending order, displaying the top-performing ad set.

### SQL Code
```sql
-- Facebook reklam verileri üzerinden ROMI hesaplaması
WITH facebook_ads AS (
    SELECT
        fa.adset_name,
        fabd.spend,
        fabd.value,
        fabd.impressions,
        fabd.clicks
    FROM
        facebook_ads_basic_daily AS fabd
    LEFT JOIN
        facebook_adset AS fa
    ON
        fabd.adset_id = fa.adset_id
    LEFT JOIN
        facebook_campaign AS fc
    ON
        fabd.campaign_id = fc.campaign_id
)

SELECT
    facebook_ads.adset_name,
    SUM(facebook_ads.spend) AS toplam_maliyet,
    SUM((facebook_ads.value - facebook_ads.spend) * 100 / facebook_ads.spend) AS ROMI
FROM
    facebook_ads
WHERE
    facebook_ads.value IS NOT NULL
    AND facebook_ads.impressions <> 0
    AND facebook_ads.clicks <> 0
    AND facebook_ads.spend <> 0
GROUP BY
    facebook_ads.adset_name
HAVING
    SUM(facebook_ads.spend) > 500000
ORDER BY
    ROMI DESC
LIMIT
    1;
```

## Explanation of Key Metrics

- **Total Revenue**: Sum of `value` for each campaign, indicating revenue generated.
- **Total Spend**: Total ad expenditure per campaign and ad set.
- **Total Impressions**: Number of times ads were shown across platforms.
- **Total Clicks**: Number of clicks recorded across platforms.
- **Conversion Rate**: Click-through rate, calculated as `(clicks * 100) / impressions`.
- **ROMI (Return on Marketing Investment)**: Reflects profitability, calculated as `(value - spend) * 100 / spend`.

## Usage

- **Run the Cross-Platform Ads Summary Query**: Analyze daily metrics for Facebook and Google ads to compare cost efficiency, reach, and conversion rates across campaigns.
- **Run the Facebook ROMI Calculation Query**: Identify high-spending Facebook ad sets with the highest ROMI, focusing on campaigns with substantial ad spend.

## Example Output

### Cross-Platform Ads Summary

| ad_date     | campaign_name | adset_name  | media_source | total_revenue | total_spend | total_impressions | total_clicks | conversion_rate |
|-------------|---------------|-------------|--------------|---------------|-------------|-------------------|--------------|-----------------|
| 2023-11-01  | Holiday Sale  | Ad Set A    | Facebook_Ads | 5000          | 1500        | 30000            | 300          | 1.0             |
| 2023-11-01  | Winter Promo  | Ad Set B    | Google_Ads   | 4500          | 1200        | 28000            | 240          | 0.86            |

### Facebook ROMI Calculation

| adset_name | toplam_maliyet | ROMI |
|------------|----------------|------|
| Ad Set A   | 600000         | 120  |

The results provide insights into cross-platform performance, including total spend, conversion rates, and profitability for Facebook ad sets.

## Author & Contact Information

This analysis was developed by a data analyst with expertise in SQL and digital advertising analytics.

For further questions:
- **GitHub Issues**: Open an issue in the repository for questions or feedback.
- **Email**: Reach out via email at [dogankaraoglu025@gmail.com](mailto:dogankaraoglu025@gmail.com).

## Additional Resources

For more SQL-based data analysis projects, visit the [Sql Join](https://github.com/Necodk/Data-Analysis-Projects/blob/main/SQL/Sql_Join.sql).
