# Transformation Logic

## Company Data Transformations
- Generated Company IDs using window function logic, cast to string, and left padding format such as C001.
- Removed unwanted columns from the raw company dataset.
- Parsed address into street, city, state, and zip using regex extraction logic.
- Created revenue status fields.
- Added revenue valid flag where valid = 1 and invalid = 0.
- Calculated revenue rank.
- Created revenue tiers for downstream analytics.

## People Data Transformations
- Generated People IDs using window function logic, cast to string, and left padding format such as P001.
- Cleaned phone numbers by removing country code, extracting extension, and keeping a standard 10-digit number.
- Normalized company names across both datasets.
- Identified and removed duplicate people records using grouping and aggregation.

## Deal and Pipeline Modeling
- Explicitly engineered deal IDs.
- Added revenue tier fields for pipeline segmentation.
- Structured deal stage and probability fields for pipeline tracking and forecasting.

## KPI Layer
- Built metrics for Open Pipeline, Closed Won Revenue, Win Rate, Top Revenue Companies, and Industry Performance.
