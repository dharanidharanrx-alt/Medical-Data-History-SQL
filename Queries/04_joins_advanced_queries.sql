-- ============================================================
-- PRSQL-02 · Medical Data History
-- Section 4: JOINs, Grouping & Advanced Queries (Q23 – Q34)
-- Analyst: Dharanidharan J
-- Database: project_medical_data_history
-- ============================================================


-- Q23: Find patients admitted multiple times for the same diagnosis
SELECT patient_id, diagnosis
FROM   project_medical_data_history.admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;


-- Q24: Show each city with total patient count — ordered by most patients, then city name
SELECT city,
       COUNT(*) AS num_patients
FROM   project_medical_data_history.patients
GROUP BY city
ORDER BY num_patients DESC, city ASC;


-- Q25: Show a combined list of all patients and doctors with their role label
-- Technique: UNION ALL to combine result sets from two tables into a single output
SELECT first_name, last_name, 'Patient' AS role
FROM   project_medical_data_history.patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role
FROM   project_medical_data_history.doctors;


-- Q26: Show all allergies ranked by frequency — excluding NULL values
SELECT allergies,
       COUNT(*) AS total_diagnosis
FROM   project_medical_data_history.patients
WHERE  allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC;


-- Q27: Show patients born in the 1970s, sorted from earliest birth date
SELECT first_name, last_name, birth_date
FROM   project_medical_data_history.patients
WHERE  YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;


-- Q28: Display full name as UPPER(last_name),lower(first_name) — ordered by first name descending
-- Example output: SMITH,jane
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM   project_medical_data_history.patients
ORDER BY first_name DESC;


-- Q29: Show province_ids where total sum of patient heights >= 7,000 cm
SELECT province_id,
       SUM(height) AS sum_height
FROM   project_medical_data_history.patients
GROUP BY province_id
HAVING SUM(height) >= 7000;


-- Q30: Show the weight difference (max − min) for patients with last name 'Maroni'
SELECT MAX(weight) - MIN(weight) AS weight_difference
FROM   project_medical_data_history.patients
WHERE  last_name = 'Maroni';


-- Q31: Show each day of the month with count of admissions — sorted busiest day first
SELECT DAY(admission_date)  AS day_of_month,
       COUNT(*)              AS num_admissions
FROM   project_medical_data_history.admissions
GROUP BY day_of_month
ORDER BY num_admissions DESC;


-- Q32: Group patients into weight bands (e.g., 100–109 → group 100) — ordered descending
-- Technique: FLOOR() + arithmetic bucketing — key pattern for discretising continuous variables
SELECT FLOOR(weight / 10) * 10  AS weight_group,
       COUNT(*)                  AS patients_in_group
FROM   project_medical_data_history.patients
GROUP BY weight_group
ORDER BY weight_group DESC;


-- Q33: Show patient obesity flag using WHO BMI formula
-- BMI = weight(kg) / height(m)² — flag isObese = 1 if BMI >= 30
-- Technique: CASE + POWER(); height / 100.0 converts cm to metres before squaring
SELECT patient_id,
       weight,
       height,
       CASE
           WHEN weight / POWER(height / 100.0, 2) >= 30 THEN 1
           ELSE 0
       END AS isObese
FROM   project_medical_data_history.patients;


-- Q34: Show patients diagnosed with 'Epilepsy' attended by a doctor whose first name is 'Lisa'
-- Technique: Multi-table JOIN chain across 3 tables: patients → admissions → doctors
-- Note: attending_doctor_id in admissions maps to doctor_id in doctors table
SELECT p.patient_id,
       p.first_name,
       p.last_name,
       d.specialty,
       a.diagnosis,
       d.first_name AS doctor_first_name
FROM   project_medical_data_history.patients p
JOIN   project_medical_data_history.admissions a
    ON p.patient_id = a.patient_id
JOIN   project_medical_data_history.doctors d
    ON a.attending_doctor_id = d.doctor_id
WHERE  a.diagnosis = 'Epilepsy'
  AND  d.first_name = 'Lisa';
