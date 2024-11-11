-- Facebook ve Google reklam verilerinin birleştirildiği CTE tanımlamaları
WITH facebook_ads AS (
    SELECT
        fabd.ad_date,
        fabd.url_parameters,
        fabd.spend,
        fabd.impressions,
        fabd.reach,
        fabd.clicks,
        fabd.leads,
        fabd.value
    FROM
        facebook_ads_basic_daily AS fabd
    LEFT JOIN
        facebook_adset AS fa
    ON
        fa.adset_id = fabd.adset_id
    LEFT JOIN
        facebook_campaign AS fc
    ON
        fc.campaign_id = fabd.campaign_id
),
all_ads_data AS (
    SELECT
        ad_date,
        url_parameters,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM
        google_ads_basic_daily
    UNION ALL
    SELECT
        ad_date,
        url_parameters,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM
        facebook_ads
),

-- Aylık bazda verilerin özetlendiği CTE
MonthlyData AS (
    SELECT
        TO_CHAR(DATE_TRUNC('month', ad_date), 'YYYY-MM-DD') AS ad_month,
        CASE
            WHEN LOWER(SUBSTRING(url_parameters FROM 'utm_campaign=([^&#$]+)')) = 'nan' THEN NULL
            ELSE LOWER(SUBSTRING(url_parameters FROM 'utm_campaign=([^&#$]+)'))
        END AS utm_campaign,
        COALESCE(SUM(spend), 0) AS total_cost,
        COALESCE(SUM(impressions), 0) AS number_of_impressions,
        COALESCE(SUM(clicks), 0) AS number_of_clicks,
        COALESCE(SUM(value), 0) AS conversion_value,
        ROUND(CASE WHEN SUM(impressions) > 0 THEN (SUM(clicks)::numeric * 100.0 / SUM(impressions)) ELSE 0 END, 2) AS ctr,
        ROUND(CASE WHEN SUM(clicks) > 0 THEN SUM(spend)::numeric / SUM(clicks) ELSE 0 END, 2) AS cpc,
        ROUND(CASE WHEN SUM(impressions) > 0 THEN (SUM(spend)::numeric * 1000.0 / SUM(impressions)) ELSE 0 END, 2) AS cpm,
        ROUND(CASE WHEN SUM(spend) > 0 THEN (SUM(value)::numeric / SUM(spend)) * 100 ELSE 0 END, 2) AS romi
    FROM
        all_ads_data
    GROUP BY
        ad_month,
        utm_campaign
),

-- Aylık değişimlerin hesaplandığı CTE
MonthlyChanges AS (
    SELECT
        ad_month,
        utm_campaign,
        total_cost,
        number_of_impressions,
        number_of_clicks,
        conversion_value,
        ctr,
        cpc,
        cpm,
        romi,
        LAG(ctr, 1) OVER (PARTITION BY utm_campaign ORDER BY ad_month) AS prev_ctr,
        LAG(cpc, 1) OVER (PARTITION BY utm_campaign ORDER BY ad_month) AS prev_cpc,
        LAG(cpm, 1) OVER (PARTITION BY utm_campaign ORDER BY ad_month) AS prev_cpm,
        LAG(romi, 1) OVER (PARTITION BY utm_campaign ORDER BY ad_month) AS prev_romi
    FROM
        MonthlyData
)

-- Nihai çıktı: Aylık veriler ve önceki aya göre yüzdelik değişimler
SELECT
    ad_month,
    utm_campaign,
    total_cost,
    number_of_impressions,
    number_of_clicks,
    conversion_value,
    ctr,
    prev_ctr,
    cpc,
    prev_cpc,
    cpm,
    prev_cpm,
    romi,
    prev_romi,
    ROUND(CASE WHEN prev_ctr = 0 OR prev_ctr IS NULL THEN NULL ELSE (ctr - prev_ctr) / prev_ctr * 100 END, 2) AS pct_change_ctr,
    ROUND(CASE WHEN prev_cpc = 0 OR prev_cpc IS NULL THEN NULL ELSE (cpc - prev_cpc) / prev_cpc * 100 END, 2) AS pct_change_cpc,
    ROUND(CASE WHEN prev_cpm = 0 OR prev_cpm IS NULL THEN NULL ELSE (cpm - prev_cpm) / prev_cpm * 100 END, 2) AS pct_change_cpm,
    ROUND(CASE WHEN prev_romi = 0 OR prev_romi IS NULL THEN NULL ELSE (romi - prev_romi) / prev_romi * 100 END, 2) AS pct_change_romi
FROM
    MonthlyChanges
ORDER BY
    ad_month,
    utm_campaign;