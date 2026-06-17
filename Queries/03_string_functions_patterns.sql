-- ============================================================
-- PRSQL-02 · Medical Data History
-- Section 3: String Functions & Pattern Matching (Q18 – Q22)
-- Analyst: Dharanidharan J
-- Database: project_medical_data_history
-- ============================================================


-- Q18: Show patient_id and first_name where name starts & ends with 'S' and is >= 6 characters
SELECT patient_id, first_name
FROM   project_medical_data_history.patients
WHERE  first_name LIKE 'S%S'
  AND  LENGTH(first_name) >= 6;


-- Q19: Show patient details where primary diagnosis is 'Dementia'
-- Note: Diagnosis is stored in the admissions table, not patients
SELECT p.patient_id,
       p.first_name,
       p.last_name,
       a.diagnosis
FROM   project_medical_data_history.patients p
JOIN   project_medical_data_history.admissions a
    ON p.patient_id = a.patient_id
WHERE  a.diagnosis = 'Dementia';


-- Q20: Display all patient first names ordered by name length, then alphabetically
SELECT first_name
FROM   project_medical_data_history.patients
ORDER BY LENGTH(first_name), first_name ASC;


-- Q21: Show total male and female patients in the same row — Method 1: CASE + SUM
-- Technique: Single-pass pivot using CASE WHEN inside aggregate (more efficient)
SELECT
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM project_medical_data_history.patients;


-- Q22: Show total male and female patients in the same row — Method 2: Correlated Subqueries
-- Technique: Two independent COUNT subqueries in the SELECT clause (more readable for simple pivots)
SELECT
    (SELECT COUNT(*) FROM project_medical_data_history.patients WHERE gender = 'M') AS male_count,
    (SELECT COUNT(*) FROM project_medical_data_history.patients WHERE gender = 'F') AS female_count;

-- Comparison Note:
-- Q21 (CASE + SUM): single table scan — preferred for large datasets
-- Q22 (subqueries): two separate scans — clearer intent for simple gender pivot queries
