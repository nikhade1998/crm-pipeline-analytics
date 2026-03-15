/* =========================================
   PEOPLE DATA TRANSFORMATIONS
   Representative SQL based on project notes
========================================= */

/* Step 1: Clean and standardize people data */
WITH people_cleaned AS (
    SELECT
        person_name,
        company_name,

        /* Remove all non-numeric characters from phone */
        REGEXP_REPLACE(phone_number, '[^0-9]', '') AS phone_digits

    FROM people_raw
),

/* Step 2: Remove country code and extract 10-digit phone */
people_phone_standardized AS (
    SELECT
        person_name,
        company_name,

        CASE
            WHEN LENGTH(phone_digits) > 10 THEN RIGHT(phone_digits, 10)
            ELSE phone_digits
        END AS cleaned_phone_number

    FROM people_cleaned
),

/* Step 3: Normalize company names */
people_normalized AS (
    SELECT
        person_name,
        UPPER(TRIM(company_name)) AS normalized_company_name,
        cleaned_phone_number
    FROM people_phone_standardized
),

/* Step 4: Add People IDs using row_number + cast + left pad */
people_with_ids AS (
    SELECT
        CONCAT(
            'P',
            LPAD(CAST(ROW_NUMBER() OVER (ORDER BY person_name) AS STRING), 3, '0')
        ) AS people_id,
        person_name,
        normalized_company_name AS company_name,
        cleaned_phone_number
    FROM people_normalized
),

/* Step 5: Mark duplicates */
people_dedup_check AS (
    SELECT
        *,
        COUNT(*) OVER (
            PARTITION BY person_name, company_name, cleaned_phone_number
        ) AS duplicate_count,
        ROW_NUMBER() OVER (
            PARTITION BY person_name, company_name, cleaned_phone_number
            ORDER BY people_id
        ) AS rn
    FROM people_with_ids
)

/* Step 6: Keep only unique rows */
SELECT
    people_id,
    person_name,
    company_name,
    cleaned_phone_number
FROM people_dedup_check
WHERE rn = 1;
