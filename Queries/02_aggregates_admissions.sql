-- ============================================================
-- PRSQL-02 · Medical Data History
-- Section 2: Aggregates & Admissions (Q11 – Q17)
-- Analyst: Dharanidharan J
-- Database: project_medical_data_history
-- ============================================================


-- Q11: Show the total number of admissions
SELECT COUNT(*) AS total_admissions
FROM   project_medical_data_history.admissions;


-- Q12: Show all admissions where the patient was admitted and discharged on the same day
SELECT *
FROM   project_medical_data_history.admissions
WHERE  admission_date = discharge_date;


-- Q13: Show total admissions for patient_id 579
SELECT COUNT(*) AS total_admission
FROM   project_medical_data_history.admissions
WHERE  patient_id = 579;


-- Q14: Show unique cities where patients live in province 'NS'
SELECT DISTINCT city
FROM   project_medical_data_history.patients
WHERE  province_id = 'NS';


-- Q15: Find patients with height > 160 cm AND weight > 70 kg
SELECT first_name, last_name, birth_date, height, weight
FROM   project_medical_data_history.patients
WHERE  height > 160
  AND  weight > 70;


-- Q16: Show unique birth years ordered ascending
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM   project_medical_data_history.patients
ORDER BY birth_year ASC;


-- Q17: Show first names that appear only once in the patients table
-- Technique: GROUP BY + HAVING to filter aggregated groups
-- Note: HAVING is required here because WHERE cannot be used with aggregate functions
SELECT first_name
FROM   project_medical_data_history.patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;
