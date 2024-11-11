/* Günlük Facebook reklam verilerinden toplam maliyet, gösterim, tıklama ve diğer metrikleri özetleyen sorgu */
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


/* Kampanya bazında belirli bir harcama eşiğini geçen reklamların özetini döndüren sorgu */
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