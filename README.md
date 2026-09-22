# CMS Medicare Provider Utilization & Cost Analysis (California)

Part 1 of a healthcare-analytics portfolio sprint (Sep 15 – Oct 1, 2026) built
in support of an application to Molina Healthcare (Analyst, Data and
Analytics – Level 1). Uses PostgreSQL to analyze CMS's public Medicare
Physician & Other Practitioners provider-and-service data, filtered to
California.

## Data source

[Medicare Physician & Other Practitioners by Provider and Service](https://data.cms.gov/provider-summary-by-type-of-service/medicare-physician-other-practitioners/medicare-physician-other-practitioners-by-provider-and-service) — CMS Data, 2024 release.

Download the CSV, filter/export to California, and place it in this folder
as `Medicare_Physician_Other_Practitioners_by_Provider_and_Service_2024.csv`
(not committed here — see `.gitignore`).

## Setup

Requires PostgreSQL. Create the database, then:

```
psql -d claims_sprint -f 01_create_table.sql
```

```
psql -d claims_sprint -c "\copy provider_service (npi,last_org_name,first_name,middle_initial,credentials,entity_code,address_line1,address_line2,city,state_abbrv,state_fips,zip5,ruca,ruca_desc,country,provider_type,medicare_participating,hcpcs_code,hcpcs_desc,hcpcs_drug_ind,place_of_service,total_beneficiaries,total_services,total_bene_day_services,avg_submitted_charge,avg_medicare_allowed,avg_medicare_payment,avg_medicare_standardized) FROM 'Medicare_Physician_Other_Practitioners_by_Provider_and_Service_2024.csv' WITH (FORMAT csv, HEADER true, NULL '', FORCE_NULL (first_name, middle_initial, credentials, address_line2, ruca, ruca_desc))"
```

Loads all 832,561 California provider/procedure rows.

Note: `total_beneficiaries`, `total_services`, and `total_bene_day_services`
are `NUMERIC`, not `INTEGER` — CMS's methodology produces fractional counts
for some drug-related HCPCS codes billed in partial units.

## Files

- `01_create_table.sql` — schema for `provider_service` (grain: one rendering
  provider + one procedure + one place of service)
- `02_top10_procedures_by_spend.sql` — top 10 procedures in California by
  total Medicare dollars paid (`SUM(total_services * avg_medicare_payment)`)

## Findings so far

Top procedure by total spend: established-patient office visits (30+ min,
moderate decision-making) at ~$934M — more than double the next closest
category. Full top-10 breakdown is reproducible via the query above.

## Roadmap

- [ ] Additional angles: top providers, spend by place of service, spend by
      provider specialty
- [ ] Build the utilization & cost dashboard (visualization layer)
- [ ] Write-up for the portfolio
