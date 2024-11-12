# Facebook Ads Data Analysis

This project includes an SQL query designed to analyze daily spending and clicks data for Facebook ads. The query calculates the cost-per-click rate and filters for days with at least one click, providing insights into ad spend efficiency.

## Query Overview

The query retrieves data from the `facebook_ads_basic_daily` table and performs the following actions:
- **Date**: Retrieves the date of each ad record (`ad_date`).
- **Ad Spend**: Retrieves the total spend amount (`spend`) for each day.
- **Clicks**: Retrieves the number of clicks (`clicks`) for each day.
- **Spend per Click**: Calculates the rate of spend per click as `spend / clicks`.
- **Filtering**: Includes only days where there was at least one click (`clicks >= 1`).
- **Sorting**: Orders the results by date in descending order, showing the most recent data first.

## SQL Query

```sql
SELECT 
    ad_date,
    spend,
    clicks,
    spend / clicks AS spend_clicks_rate
FROM 
    facebook_ads_basic_daily
WHERE 
    clicks >= 1
ORDER BY 
    ad_date DESC;
```
## Explanation of Key Components

- **Spend per Click Calculation**: The query calculates the cost-per-click rate (`spend / clicks`) to help measure the efficiency of the ad spend in generating clicks.
- **Filtering by Clicks**: Filtering for records where `clicks >= 1` ensures that we only analyze days with meaningful data, as calculating spend per click would not be valid for zero clicks.
- **Sorting by Date**: The `ORDER BY ad_date DESC` clause sorts the results by the most recent dates, making it easier to track trends over time.

## Usage

1. Run the query in your SQL environment to retrieve daily ad spend and clicks data.
2. Use the results to monitor the cost-effectiveness of Facebook ad campaigns and adjust strategies based on spend-per-click trends.
3. Modify the `WHERE` or `ORDER BY` clauses as needed to apply further filters or customize sorting.

## Example Output

| ad_date     | spend | clicks | spend_clicks_rate |
|-------------|-------|--------|-------------------|
| 2023-11-01  | 150   | 30     | 5.0               |
| 2023-10-31  | 200   | 40     | 5.0               |
| 2023-10-30  | 100   | 20     | 5.0               |

The output provides insight into daily ad spending efficiency, helping advertisers evaluate cost per click over time.

## Author & Contact Information

This project was created by a data analyst proficient in SQL and database management.

For further questions:
- **GitHub Issues**: Open an issue in the repository to ask questions or provide feedback.
- **Email**: Reach out via email at [dogankaraoglu025@gmail.com](mailto:dogankaraoglu025@gmail.com).

## Additional Resources

For more SQL projects and resources, visit the [Sql Basic](https://github.com/Necodk/Data-Analysis-Projects/blob/main/SQL/Sql_Basic.sql).
