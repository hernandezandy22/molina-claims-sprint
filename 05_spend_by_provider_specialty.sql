-- Top 15 provider specialties (provider_type) in California by total
-- Medicare dollars paid, with number of distinct billing providers and
-- average spend per provider in that specialty -- flags specialties that
-- are high-cost because of a few big billers vs. broad volume.

SELECT
    provider_type,
    COUNT(DISTINCT npi) AS provider_count,
    SUM(total_services * avg_medicare_payment) AS total_spent,
    ROUND(SUM(total_services * avg_medicare_payment) / COUNT(DISTINCT npi), 2) AS avg_spend_per_provider
FROM provider_service
GROUP BY provider_type
ORDER BY total_spent DESC
LIMIT 15;
