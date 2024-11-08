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