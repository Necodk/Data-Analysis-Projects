# UTM Campaign Analysis with Facebook and Google Ads

This project includes SQL queries designed to analyze UTM campaign parameters from Facebook and Google ads data. These queries calculate key ad metrics for each campaign and provide insights into performance across different UTM campaign tags.

## Query Overview

### Primary Query: Campaign Metrics by UTM Parameters
This query calculates aggregated metrics for Facebook and Google ad campaigns based on UTM parameters, offering insights into daily spending, click performance, impressions, and return on marketing investment (ROMI).

1. **CTE Definitions**:
   - `futm_parameter`: Extracts Facebook ad data, including UTM parameters, spend, clicks, impressions, and other key metrics.
   - `gutm_parameter`: Extracts similar data from Google ads, enabling cross-platform comparisons.

2. **Metric Calculations**:
   - **Total Spend**: Sum of ad spend per day and campaign.
   - **Total Clicks**: Sum of all clicks per campaign.
   - **Total Impressions**: Total number of impressions.
   - **Conversion Rate**: Calculated as `(clicks * 100) / impressions`.
   - **CPC (Cost per Click)**: Spend per click, calculated as `spend / clicks`.
   - **CPM (Cost per Thousand Impressions)**: Spend per 1,000 impressions.
   - **CTR (Click-through Rate)**: Percentage of impressions that resulted in clicks.
   - **ROMI (Return on Marketing Investment)**: Calculated as `(value - spend) * 100 / spend`, showing profitability relative to ad spend.

The query groups results by `ad_date` and `utm_campaign` to provide a breakdown of daily performance for each campaign.

### SQL Code

```sql
WITH futm_parameter AS (
    SELECT
        fabd.ad_date,
        fabd.url_parameters,
        fabd.spend,
        fabd.clicks,
        fabd.impressions,
        fabd.reach,
        fabd.leads,
        fabd.value
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
gutm_parameter AS (
    SELECT
        ad_date,
        url_parameters,
        spend,
        clicks,
        impressions,
        reach,
        leads,
        value
    FROM
        google_ads_basic_daily AS gabd
)

-- Kampanya bazında metrik hesaplamaları
SELECT
    ad_date,
    LOWER(
        CASE
            WHEN SUBSTRING(url_parameters, 'utm_campaign=([^&]+)') = 'nan' THEN NULL
            ELSE SUBSTRING(url_parameters, 'utm_campaign=([^&]+)')
        END
    ) AS utm_campaign,
    SUM(spend) AS total_spend,
    SUM(clicks) AS total_clicks,
    SUM(impressions) AS total_impressions,
    SUM(CASE WHEN impressions <> 0 THEN clicks * 100 / impressions ELSE 0 END) AS conversion_rate,
    SUM(CASE WHEN clicks <> 0 THEN spend / clicks ELSE 0 END) AS cpc,
    SUM(CASE WHEN impressions <> 0 THEN spend * 1000 / impressions ELSE 0 END) AS cpm,
    SUM(CASE WHEN impressions <> 0 THEN clicks * 100 / impressions ELSE 0 END) AS ctr,
    SUM(CASE WHEN spend <> 0 THEN (value - spend) * 100 / spend ELSE 0 END) AS romi
FROM (
    SELECT * FROM futm_parameter
    UNION ALL
    SELECT * FROM gutm_parameter
) AS Task_6
GROUP BY
    ad_date,
    utm_campaign
ORDER BY
    ad_date DESC;
```

## Bonus Query: Decoding UTM Campaign Parameters

This bonus query provides an alternative method for extracting and decoding UTM parameters for campaign grouping. It uses a CTE to extract UTM campaign names and groups results by `ad_date` and `utm_campaign` to give a clear view of campaign distribution.

### SQL Code

```sql
WITH futm_parameter AS (
    SELECT
        fabd.ad_date,
        decode_url_part(fabd.url_parameters) AS utm_campaign,
        fabd.spend,
        fabd.clicks,
        fabd.impressions,
        fabd.reach,
        fabd.leads,
        fabd.value
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
gutm_parameter AS (
    SELECT
        ad_date,
        decode_url_part(url_parameters) AS utm_campaign,
        spend,
        clicks,
        impressions,
        reach,
        leads,
        value
    FROM
        google_ads_basic_daily AS gabd
)

-- Kampanya adlarını çözümleyip gruplama
SELECT
    LOWER(
        CASE
            WHEN SUBSTRING(utm_campaign, 'utm_campaign=([^&]+)') = 'nan' THEN NULL
            ELSE SUBSTRING(utm_campaign, 'utm_campaign=([^&]+)')
        END
    ) AS utm_campaign
FROM (
    SELECT * FROM futm_parameter
    UNION ALL
    SELECT * FROM gutm_parameter
) AS Task_6_Bonus
GROUP BY 
    ad_date,
    utm_campaign;
```

## Explanation of Key Metrics

- **Total Spend**: Sum of ad spend per day and campaign.
- **Total Clicks**: Total number of clicks per campaign.
- **Total Impressions**: Total number of impressions.
- **Conversion Rate**: Percentage of impressions that resulted in clicks, calculated as `(clicks * 100) / impressions`.
- **CPC (Cost per Click)**: Cost per click, calculated as `spend / clicks`.
- **CPM (Cost per Thousand Impressions)**: Spend per 1,000 impressions.
- **CTR (Click-through Rate)**: Measures engagement by showing the percentage of impressions that led to clicks.
- **ROMI (Return on Marketing Investment)**: Profitability ratio calculated as `(value - spend) * 100 / spend`.

## Usage

- **Run the Campaign Metrics Query**: To get daily performance insights for each campaign based on UTM parameters.
- **Run the Bonus Query**: For an alternative way to decode and group campaign names by UTM parameter, making it easier to analyze campaign distribution.

## Example Output

### Campaign Metrics by UTM Parameters

| ad_date     | utm_campaign | total_spend | total_clicks | total_impressions | conversion_rate | cpc  | cpm  | ctr  | romi |
|-------------|--------------|-------------|--------------|-------------------|-----------------|------|------|------|------|
| 2023-11-01  | fall_promo   | 2000        | 400          | 50000            | 0.8             | 5.0  | 40   | 0.8  | 100  |

### UTM Campaign Decoding (Bonus Query)

| ad_date     | utm_campaign |
|-------------|--------------|
| 2023-11-01  | fall_promo   |

## Author & Contact Information

This analysis was developed by a data analyst with expertise in SQL and digital advertising analytics.

For further questions:
- **GitHub Issues**: Open an issue in the repository for questions or feedback.
- **Email**: Reach out via email at [dogankaraoglu025@gmail.com](mailto:dogankaraoglu025@gmail.com).

## Additional Resources

For more SQL-based data analysis projects, visit the [Data Cleaning and String Functions](https://github.com/Necodk/Data-Analysis-Projects/blob/main/SQL/Sql_DataCleaning_StringFunction.sql).




