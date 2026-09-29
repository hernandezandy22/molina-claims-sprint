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
- `03_top10_providers_by_spend.sql` — top 10 individual/organizational
  providers (by NPI) by total Medicare dollars paid across everything they
  billed
- `04_spend_by_place_of_service.sql` — total spend split between facility vs.
  office settings, with each one's share of the grand total
- `05_spend_by_provider_specialty.sql` — top 15 provider specialties by total
  spend, with provider count and average spend per provider

## Findings so far

**Top procedure by spend:** established-patient office visits (30+ min,
moderate decision-making) at ~$934M — more than double the next closest
category. Office-visit codes dominate the top 5.

**Office vs. facility spend:** 75.4% of total California Medicare spend
($9.67B) happens in office settings vs. 24.6% ($3.16B) in facility
settings — routine outpatient care outweighs institutional/facility care by
roughly 3-to-1.

**Spend by specialty:** Clinical Laboratory leads total spend ($1.64B)
despite only 322 billing providers statewide — an average of ~$5.1M per
provider, by far the highest of any specialty. That's concentration, not
volume: compare to Internal Medicine ($1.05B total across 9,380 providers,
~$112K average) or Nurse Practitioner ($500M across 7,796 providers,
~$64K average), which post large totals through broad participation
instead. Ambulance Service Provider (~$1.73M avg, 253 providers) and
Independent Diagnostic Testing Facilities (~$1.6M avg, 226 providers) show
the same concentrated pattern.

**Top individual providers:** 7 of the top 10 billers statewide are
molecular/genomic diagnostic labs or remote cardiac monitoring companies
(Guardant Health, Natera, CareDx, Veracyte, Genomic Health, iRhythm,
CardioNet) rather than individual physicians — confirming the Clinical
Laboratory/IDTF concentration seen in the specialty breakdown. Only 2 of
the top 10 are individual physicians (entity_code 'I').

## Roadmap

- [x] Additional angles: top providers, spend by place of service, spend by
      provider specialty
- [ ] Build the utilization & cost dashboard (visualization layer)
- [ ] Write-up for the portfolio
