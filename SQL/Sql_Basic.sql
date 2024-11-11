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