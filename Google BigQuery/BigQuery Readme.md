# E-commerce Funnel Analysis with GA4 Data

This project contains SQL scripts designed to analyze user behavior and conversion rates through the e-commerce funnel using Google Analytics 4 (GA4) data from BigQuery's public dataset. The analysis focuses on tracking key user interactions across different stages, such as adding items to the cart, beginning checkout, and completing a purchase, with breakdowns by traffic source and campaign.

## Dataset

The data is sourced from BigQuery's `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` dataset, which contains GA4 event data for an e-commerce sample.

## Objectives

1. **Retrieve and Group Event Data**: Extract relevant event data and group it by basic user information, focusing on events like `session_start`, `view_item`, `add_to_cart`, `begin_checkout`, `add_shipping_info`, `add_payment_info`, and `purchase`.
2. **Analyze User Sessions and Conversion Rates**: Calculate conversion rates for different stages of the e-commerce funnel, allowing for insights into user behavior and effectiveness of traffic sources and campaigns.

## SQL Workflow

### Task 1: Retrieve Event Data and Basic User Information

This query retrieves and groups event data by user session details, focusing on relevant e-commerce events. It is designed to provide a foundation for the analysis by capturing essential user interaction data.

- **event_timestamp**: Timestamp of each event.
- **user_pseudo_id**: Anonymized unique identifier for users.
- **session_id**: Session ID for tracking sessions, extracted from `event_params`.
- **event_name**: Type of event (e.g., `add_to_cart`, `purchase`).
- **geo.country**: User's country.
- **device.category**: Device category (e.g., mobile, desktop).
- **traffic_source**: Source, medium, and campaign for user acquisition.

#### SQL Code

```sql
SELECT
  DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_timestamp,
  user_pseudo_id,
  (
    SELECT
      value.int_value
    FROM
      UNNEST(event_params)
    WHERE
      KEY = 'ga_session_id'
  ) AS session_id,
  event_name,
  geo.country,
  device.category,
  traffic_source.source,
  traffic_source.medium,
  traffic_source.name AS campaign
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name IN ('session_start', 'view_item', 'add_to_cart', 'begin_checkout', 'add_shipping_info', 'add_payment_info', 'purchase')
  AND _TABLE_SUFFIX IN ('20210101', '20211231')
GROUP BY
  1, 2, 3, 4, 5, 6, 7, 8, 9;
```
## Click here for the [query result](https://github.com/Necodk/Data-Analysis-Projects/blob/main/Google%20BigQuery/BQ_Query.csv).



### Task 2: Analyze User Sessions and Conversion Rates

This query builds on the data retrieved in Task 1 to calculate user sessions and conversion rates for different stages in the e-commerce funnel. It provides key metrics to assess the effectiveness of traffic sources and campaigns in driving user engagement through the funnel.

#### Conversion Metrics

- **Visit-to-Cart Conversion Rate**: Percentage of sessions that lead to an add-to-cart event.
- **Visit-to-Checkout Conversion Rate**: Percentage of sessions that lead to a begin-checkout event.
- **Visit-to-Purchase Conversion Rate**: Percentage of sessions that lead to a purchase event.

The analysis uses two Common Table Expressions (CTEs):

- **query**: Filters relevant events, extracting session information and traffic source data.
- **query2**: Aggregates session counts and calculates conversion events for add-to-cart, checkout, and purchase stages.

#### SQL Code

```sql
WITH
  query AS (
    SELECT
      DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date,
      event_name,
      traffic_source.source AS ssource,
      traffic_source.medium AS medium,
      traffic_source.name AS campaign,
      (
        SELECT
          value.int_value
        FROM
          UNNEST(event_params)
        WHERE
          KEY = 'ga_session_id'
      ) AS user_session_id
    FROM
      `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE
      event_name IN ('session_start', 'add_to_cart', 'begin_checkout', 'purchase')
  ),
  query2 AS (
    SELECT
      event_date,
      ssource,
      medium,
      campaign,
      event_name,
      COUNT(DISTINCT CASE WHEN event_name LIKE '%add_to_cart%' THEN 1 END) AS add_to_cart_count,
      COUNT(DISTINCT CASE WHEN event_name LIKE '%begin_checkout%' THEN 1 END) AS begin_checkout_count,
      COUNT(DISTINCT CASE WHEN event_name LIKE '%purchase%' THEN 1 END) AS purchase_count,
      COUNT(DISTINCT user_session_id) AS user_sessions_count
    FROM
      query
    GROUP BY
      1, 2, 3, 4, 5
  )
SELECT
  query2.event_date,
  query2.ssource,
  query2.medium,
  query2.campaign,
  event_name,
  query2.user_sessions_count,
  add_to_cart_count / query2.user_sessions_count AS visit_to_cart,
  begin_checkout_count / query2.user_sessions_count AS visit_to_checkout,
  purchase_count / query2.user_sessions_count AS visit_to_purchase
FROM
  query2;
```
## Click here for the [query result](https://github.com/Necodk/Data-Analysis-Projects/blob/main/Google%20BigQuery/BQ_CTE_Query.csv).

### Key Metrics

The analysis provides the following conversion metrics:

- **Visit-to-Cart Conversion Rate**: Percentage of sessions that lead to an add-to-cart event.
- **Visit-to-Checkout Conversion Rate**: Percentage of sessions that lead to a begin-checkout event.
- **Visit-to-Purchase Conversion Rate**: Percentage of sessions that lead to a purchase event.

### Usage

To run this analysis:

1. Open BigQuery in Google Cloud Platform.
2. Run each SQL script in sequence to retrieve data, calculate session-based metrics, and analyze conversion rates.

### Contact

For further information or questions:

- **GitHub Issues**: If you have any questions or issues, please open a [GitHub Issue](https://github.com/Necodk/Data-Analysis-Projects/issues).
- **Email**: Reach out via email at [dogankaraoglu025@gmail.com](mailto:dogankaraoglu025@gmail.com).

## Additional Resources

For more information or to view To the project, please visit the [BigQuery Project](https://console.cloud.google.com/bigquery?hl=tr&project=proven-mind-429519-f8&ws=!1m4!1m3!8m2!1s441610422913!2s374324d4b984498096f6b765ab7e0c7e).
