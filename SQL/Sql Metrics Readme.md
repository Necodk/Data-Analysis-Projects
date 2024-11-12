# Facebook Ads Performance Analysis

This project contains SQL queries designed to analyze daily Facebook ad performance, providing insights into metrics such as total cost, impressions, clicks, cost-per-click (CPC), cost-per-thousand impressions (CPM), click-through rate (CTR), and return on marketing investment (ROMI). These queries are intended to support data-driven decision-making for optimizing ad campaigns.

## Overview of Queries

### 1. Daily Ad Performance Summary

This query calculates daily performance metrics for each campaign, including:
- **Total Cost**: The sum of ad spend.
- **Total Impressions**: Total number of impressions.
- **Total Clicks**: Total clicks for each campaign.
- **Total Value**: Revenue generated from the ads.
- **CPC (Cost per Click)**: Average cost incurred per click.
- **CPM (Cost per Thousand Impressions)**: Cost per 1,000 impressions.
- **CTR (Click-through Rate)**: Percentage of impressions that resulted in clicks.
- **ROMI (Return on Marketing Investment)**: Return on marketing investment as a percentage, calculated as `(value - spend) * 100 / spend`.

The query groups results by `ad_date` and `campaign_id` to generate daily summaries for each campaign.

### 2. Campaign Summary with Spending Threshold

This query provides a summary of campaigns that exceed a specified spending threshold:
- **Total Spend**: The sum of ad spend for each campaign.
- **ROMI**: Return on marketing investment for each campaign, calculated as `(value - spend) * 100 / spend`.

The query groups results by `campaign_id` and applies a spending threshold of $500,000, returning campaigns that meet or exceed this value.

## Query Details

### Daily Ad Performance Summary Query

This query retrieves a comprehensive daily performance summary for each campaign from the `facebook_ads_basic_daily` table, calculating core ad metrics while filtering for records where `impressions`, `clicks`, and `spend` are non-zero and `value` is not null.

```sql
SELECT
    ad_date,
    campaign_id,
    SUM(spend) AS total_cost,
    SUM(impressions) AS total_impression,
    SUM(clicks) AS total_clicks,
    SUM(value) AS total_value,
    SUM(spend / clicks) AS cpc,
    SUM(spend * 1000 / impressions) AS cpm,
    SUM(clicks * 100 / impressions) AS ctr,
    SUM((value - spend) * 100 / spend) AS romi
FROM
    facebook_ads_basic_daily AS fabd
WHERE
    value IS NOT NULL
    AND impressions <> 0
    AND clicks <> 0
    AND spend <> 0
GROUP BY
    ad_date,
    campaign_id;
```
## Campaign Summary with Spending Threshold Query

This query identifies campaigns with significant spending by grouping results by campaign_id and filtering for campaigns with a total spend above $500,000. It also calculates ROMI to measure campaign effectiveness.
```
SELECT
    campaign_id,
    SUM(spend) AS total_spend,
    SUM((value - spend) * 100 / spend) AS romi
FROM
    facebook_ads_basic_daily AS fabd
WHERE
    spend <> 0
GROUP BY
    campaign_id
HAVING
    SUM(spend) > 500000
LIMIT 1;
```
## Explanation of Key Metrics

- **CPC (Cost per Click)**: Measures the average cost incurred each time a user clicks on the ad. It’s calculated as `spend / clicks`.
- **CPM (Cost per Thousand Impressions)**: Shows the cost per 1,000 impressions of the ad, calculated as `spend * 1000 / impressions`.
- **CTR (Click-through Rate)**: Reflects user engagement by showing the percentage of impressions that led to clicks, calculated as `(clicks * 100) / impressions`.
- **ROMI (Return on Marketing Investment)**: Indicates the profitability of the ad campaign, calculated as `(value - spend) * 100 / spend`.

## Usage

- **Daily Ad Performance Summary Query**: Run this query to get daily insights into ad performance metrics for each campaign. Use these insights to monitor cost efficiency and engagement over time.
- **Campaign Summary with Spending Threshold Query**: Run this query to identify high-spending campaigns and evaluate their ROMI. This helps in prioritizing campaigns with higher investments and assessing their return.

## Example Output

### Daily Ad Performance Summary

| ad_date     | campaign_id | total_cost | total_impression | total_clicks | total_value | cpc  | cpm  | ctr  | romi |
|-------------|-------------|------------|------------------|--------------|-------------|------|------|------|------|
| 2023-11-01  | 12345       | 1500       | 30000           | 450          | 3000        | 3.33 | 50   | 1.5  | 100  |

### Campaign Summary with Spending Threshold

| campaign_id | total_spend | romi |
|-------------|-------------|------|
| 12345       | 600000      | 120  |

## Author & Contact Information

This analysis was developed by a data analyst with expertise in SQL and marketing analytics.

For further questions:
- **GitHub Issues**: Open an issue in the repository for questions or feedback.
- **Email**: Reach out via email at [dogankaraoglu025@gmail.com](mailto:dogankaraoglu025@gmail.com).

## Additional Resources

For more SQL-based data analysis projects, visit the [Sql Metrics](https://github.com/Necodk/Data-Analysis-Projects/blob/main/SQL/Sql_Metrics.sql).
