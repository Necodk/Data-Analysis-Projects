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