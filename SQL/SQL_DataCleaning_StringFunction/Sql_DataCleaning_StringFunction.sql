-- Facebook ve Google reklam verilerinden UTM kampanya verilerini analiz eden CTE tanımlamaları

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


-- Bonus: UTM kampanya verilerini çözümleyen alternatif CTE tanımlamaları

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