-- ============================================================
-- PRSQL-02 · Medical Data History
-- Section 1: Basic SELECT & Filtering (Q1 – Q10)
-- Analyst: Dharanidharan J
-- Database: project_medical_data_history
-- ============================================================


-- Q1: Show first name, last name, and gender of patients whose gender is 'M'
SELECT first_name, last_name, gender
FROM   project_medical_data_history.patients
WHERE  gender = 'M';


-- Q2: Show first name and last name of patients who do not have allergies
SELECT first_name, last_name
FROM   project_medical_data_history.patients
WHERE  allergies IS NULL;


-- Q3: Show first name of patients that start with the letter 'C'
SELECT first_name
FROM   project_medical_data_history.patients
WHERE  first_name LIKE 'C%';


-- Q4: Show first name and last name of patients with weight between 100 and 120 (inclusive)
SELECT first_name, last_name, weight
FROM   project_medical_data_history.patients
WHERE  weight BETWEEN 100 AND 120;


-- Q5: Replace NULL allergies with 'NKA' (No Known Allergies)
-- Technique: COALESCE() returns the first non-NULL value — standard data-cleansing for missing values
SELECT patient_id,
       first_name,
       last_name,
       COALESCE(allergies, 'NKA') AS allergies
FROM   project_medical_data_history.patients;


-- Q6: Show first name and last name concatenated as full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM   project_medical_data_history.patients;


-- Q7: Show first name, last name, and full province name for each patient
-- Technique: INNER JOIN on FK relationship between patients and province_names lookup table
SELECT p.first_name,
       p.last_name,
       pn.province_name
FROM   project_medical_data_history.patients p
JOIN   project_medical_data_history.province_names pn
    ON p.province_id = pn.province_id;


-- Q8: Count patients born in 2010
SELECT COUNT(*) AS total_patients
FROM   project_medical_data_history.patients
WHERE  YEAR(birth_date) = 2010;


-- Q9: Show first name, last name, and height of the tallest patient (two approaches)

-- Method 1: Simple and readable — returns 1 row
SELECT first_name, last_name, height
FROM   project_medical_data_history.patients
ORDER BY height DESC
LIMIT 1;

-- Method 2: Handles ties correctly — returns all patients sharing the maximum height
SELECT first_name, last_name, height
FROM   project_medical_data_history.patients
WHERE  height = (SELECT MAX(height)
                 FROM project_medical_data_history.patients);


-- Q10: Show all columns for patients with patient_ids: 1, 45, 534, 879, 1000
SELECT *
FROM   project_medical_data_history.patients
WHERE  patient_id IN (1, 45, 534, 879, 1000);
