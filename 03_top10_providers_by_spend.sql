-- Top 10 individual/organizational providers in California by total Medicare
-- dollars paid, summed across every procedure they billed.
-- Grouped by NPI (the stable provider identifier) since names can repeat
-- across different providers, and to keep individuals and orgs distinct.

SELECT
    npi,
    MAX(last_org_name) AS provider_name,
    MAX(provider_type) AS provider_type,
    MAX(entity_code)   AS entity_code,   -- 'I' individual, 'O' organization
    SUM(total_services * avg_medicare_payment) AS total_spent
FROM provider_service
GROUP BY npi
ORDER BY total_spent DESC
LIMIT 10;
