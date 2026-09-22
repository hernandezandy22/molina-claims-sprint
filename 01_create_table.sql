-- Medicare Physician & Other Practitioners by Provider and Service (2024)
-- Filtered to California by Andy before download.
-- One row = one rendering provider + one procedure (HCPCS code) + one place of service.

CREATE TABLE IF NOT EXISTS provider_service (
    npi                 BIGINT       NOT NULL,   -- Rndrng_NPI: provider's National Provider Identifier
    last_org_name       TEXT,                     -- org name if entity is a group, else provider last name
    first_name          TEXT,                     -- blank for organizational providers (Ent_Cd = 'O')
    middle_initial      TEXT,
    credentials         TEXT,
    entity_code         CHAR(1),                  -- 'I' = individual, 'O' = organization
    address_line1       TEXT,
    address_line2       TEXT,
    city                TEXT,
    state_abbrv         CHAR(2),
    state_fips          TEXT,                     -- kept as TEXT: FIPS codes can carry leading zeros
    zip5                TEXT,                     -- kept as TEXT for the same reason
    ruca                NUMERIC(4,1),              -- rural-urban commuting area code
    ruca_desc           TEXT,
    country             TEXT,
    provider_type       TEXT,                     -- specialty, e.g. 'Cardiac Surgery'
    medicare_participating CHAR(1),                -- 'Y' / 'N'
    hcpcs_code          TEXT       NOT NULL,       -- procedure code (can include letters, e.g. G0438)
    hcpcs_desc          TEXT,
    hcpcs_drug_ind       CHAR(1),
    place_of_service     CHAR(1),                  -- 'F' facility, 'O' office
    total_beneficiaries   NUMERIC(12,1),
    total_services        NUMERIC(12,1),
    total_bene_day_services NUMERIC(12,1),
    avg_submitted_charge   NUMERIC(12,2),
    avg_medicare_allowed   NUMERIC(12,2),
    avg_medicare_payment   NUMERIC(12,2),           -- what we'll usually mean by "cost" / spend per service
    avg_medicare_standardized NUMERIC(12,2),
    PRIMARY KEY (npi, hcpcs_code, place_of_service)  -- matches the natural grain we confirmed has zero duplicates
);
