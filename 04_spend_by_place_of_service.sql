-- Total Medicare spend split between facility ('F') and office ('O')
-- place-of-service settings, with each setting's share of the grand total.
-- Useful for spotting how much cost is happening in higher-overhead
-- facility settings vs. lower-cost office visits.

SELECT
    CASE place_of_service
        WHEN 'F' THEN 'Facility'
        WHEN 'O' THEN 'Office'
        ELSE place_of_service
    END AS setting,
    SUM(total_services * avg_medicare_payment) AS total_spent,
    ROUND(
        100.0 * SUM(total_services * avg_medicare_payment)
        / SUM(SUM(total_services * avg_medicare_payment)) OVER (), 1
    ) AS pct_of_total
FROM provider_service
GROUP BY place_of_service
ORDER BY total_spent DESC;
