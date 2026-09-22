-- Top 10 procedures in California by total Medicare dollars paid.
-- "Dollars paid" = avg_medicare_payment (what Medicare actually reimbursed),
-- not avg_submitted_charge (what the provider billed -- those can differ a lot).
-- Grouped across all providers performing each procedure, since one HCPCS code
-- appears as a separate row per rendering provider.

SELECT
    hcpcs_desc,
    SUM(total_services * avg_medicare_payment) AS total_spent
FROM provider_service
GROUP BY hcpcs_desc
ORDER BY total_spent DESC
LIMIT 10;
