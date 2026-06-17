# 🏥 Medical Data History — SQL Analytics Project
### PRSQL-02 | Analyst: Dharanidharan J

![SQL](https://img.shields.io/badge/SQL-MySQL-blue?style=flat-square&logo=mysql)
![Domain](https://img.shields.io/badge/Domain-Healthcare-green?style=flat-square)
![Queries](https://img.shields.io/badge/Queries-34-orange?style=flat-square)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner%20→%20Advanced-red?style=flat-square)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat-square)

---

## 📌 Project Summary

End-to-end SQL data analysis on a **relational medical database** — covering **34 progressively complex queries** across filtering, aggregation, string manipulation, multi-table JOINs, subqueries, and derived health metrics.

This project demonstrates practical SQL proficiency applied to real-world healthcare data: extracting patient records, analysing hospital admissions, computing clinical indicators (BMI), and generating population-level insights directly applicable to data analytics and business intelligence roles.

---

## 🗃️ Dataset Overview

| Detail | Value |
|---|---|
| **Database** | `project_medical_data_history` |
| **Query Language** | MySQL (Standard SQL) |
| **Domain** | Healthcare — Patient Records & Hospital Admissions |
| **Tables** | `patients`, `admissions`, `doctors`, `province_names` |

### Table Schemas

<details>
<summary><b>patients</b></summary>

| Column | Type | Description |
|---|---|---|
| patient_id | INT (PK) | Unique patient identifier |
| first_name | VARCHAR | Patient's first name |
| last_name | VARCHAR | Patient's last name |
| birth_date | DATE | Date of birth |
| city | VARCHAR | City of residence |
| province_id | CHAR | FK → province_names |
| allergies | VARCHAR | Known allergies (nullable) |
| height | INT | Height in centimetres |
| weight | INT | Weight in kilograms |
| gender | CHAR | M / F |

</details>

<details>
<summary><b>admissions</b></summary>

| Column | Type | Description |
|---|---|---|
| patient_id | INT (FK) | References patients.patient_id |
| admission_date | DATE | Date of hospital admission |
| discharge_date | DATE | Date of discharge |
| diagnosis | VARCHAR | Primary medical diagnosis |
| attending_doctor_id | INT (FK) | References doctors.doctor_id |

> ⚠️ **Note:** Column `attending_doctor_id` must be aliased as `doctor_id` when joining with the `doctors` table.

</details>

<details>
<summary><b>doctors</b></summary>

| Column | Type | Description |
|---|---|---|
| doctor_id | INT (PK) | Unique doctor identifier |
| first_name | VARCHAR | Doctor's first name |
| last_name | VARCHAR | Doctor's last name |
| specialty | VARCHAR | Medical specialisation |

</details>

<details>
<summary><b>province_names</b></summary>

| Column | Type | Description |
|---|---|---|
| province_id | CHAR (PK) | Short province code (e.g., `NS`) |
| province_name | VARCHAR | Full province name |

</details>

---

## 🔍 SQL Query Index (34 Queries)

### Section 1 — Basic SELECT & Filtering (Q1–Q10)

| # | Question | Key Technique |
|---|---|---|
| Q1 | Male patients — first name, last name, gender | `WHERE gender = 'M'` |
| Q2 | Patients with no known allergies | `WHERE allergies IS NULL` |
| Q3 | Patients whose first name starts with 'C' | `LIKE 'C%'` |
| Q4 | Patients with weight between 100–120 kg | `BETWEEN` |
| Q5 | Replace NULL allergies with 'NKA' | `COALESCE()` |
| Q6 | Full name in a single column | `CONCAT()` |
| Q7 | Patient's full province name via JOIN | `INNER JOIN` |
| Q8 | Count patients born in 2010 | `YEAR()` + `COUNT()` |
| Q9 | Patient with the greatest height (2 methods) | `ORDER BY` + `LIMIT` / `MAX()` subquery |
| Q10 | All columns for specific patient IDs | `IN (1, 45, 534, 879, 1000)` |

### Section 2 — Aggregates & Admissions (Q11–Q17)

| # | Question | Key Technique |
|---|---|---|
| Q11 | Total number of admissions | `COUNT(*)` |
| Q12 | Same-day admissions and discharges | Date equality filter |
| Q13 | Total admissions for patient_id 579 | `COUNT()` + `WHERE` |
| Q14 | Unique cities in province 'NS' | `DISTINCT` |
| Q15 | Patients with height > 160 AND weight > 70 | Compound `WHERE` |
| Q16 | Unique birth years in ascending order | `DISTINCT` + `YEAR()` + `ORDER BY` |
| Q17 | First names that appear exactly once | `GROUP BY` + `HAVING COUNT = 1` |

### Section 3 — String Functions & Pattern Matching (Q18–Q22)

| # | Question | Key Technique |
|---|---|---|
| Q18 | Names starting & ending with 'S', ≥ 6 chars | `LIKE 'S%S'` + `LENGTH()` |
| Q19 | Patients diagnosed with 'Dementia' | Cross-table `JOIN` on diagnosis |
| Q20 | First names ordered by length, then alphabetically | `ORDER BY LENGTH(), ASC` |
| Q21 | Male vs. female count in one row — Method 1 | `CASE WHEN` + `SUM()` |
| Q22 | Male vs. female count in one row — Method 2 | Correlated subqueries |

### Section 4 — JOINs, Grouping & Advanced Queries (Q23–Q34)

| # | Question | Key Technique |
|---|---|---|
| Q23 | Patients admitted multiple times for same diagnosis | `GROUP BY` + `HAVING COUNT > 1` |
| Q24 | City-level patient count, sorted by volume | `GROUP BY` + `ORDER BY` multi-column |
| Q25 | Combined patients + doctors list with role label | `UNION ALL` |
| Q26 | Allergy frequency ranking (nulls excluded) | `GROUP BY` + `ORDER BY DESC` |
| Q27 | Patients born in the 1970s, sorted by birth date | `BETWEEN 1970 AND 1979` |
| Q28 | Full name as UPPER(last),lower(first) descending | `UPPER()` + `LOWER()` + `CONCAT()` |
| Q29 | Provinces where total patient height ≥ 7,000 cm | `HAVING SUM(height) >= 7000` |
| Q30 | Weight range (max − min) for patients named 'Maroni' | `MAX() - MIN()` |
| Q31 | Admissions per day of month, sorted busiest first | `DAY()` + `GROUP BY` + `ORDER BY` |
| Q32 | Patients grouped into weight bands (100s grouping) | `FLOOR(weight / 10) * 10` |
| Q33 | Obesity flag using WHO BMI formula | `CASE WHEN` + `POWER()` |
| Q34 | Epilepsy patients under doctor named 'Lisa' | 3-table JOIN chain |

---

## 💡 Sample Queries

### Q9 — Tallest Patient (Two Approaches)
```sql
-- Method 1: Simple & readable
SELECT first_name, last_name, height
FROM   project_medical_data_history.patients
ORDER BY height DESC
LIMIT 1;

-- Method 2: Handles ties correctly (multiple patients at max height)
SELECT first_name, last_name, height
FROM   project_medical_data_history.patients
WHERE  height = (SELECT MAX(height) FROM project_medical_data_history.patients);
```

### Q33 — Obesity Flag Using WHO BMI Formula
```sql
-- BMI = weight(kg) / height(m)² — flag isObese = 1 if BMI ≥ 30
SELECT patient_id, weight, height,
       CASE
           WHEN weight / POWER(height / 100.0, 2) >= 30 THEN 1
           ELSE 0
       END AS isObese
FROM   project_medical_data_history.patients;
```

### Q34 — Multi-Table JOIN: Epilepsy Patients Under Dr. Lisa
```sql
SELECT p.patient_id, p.first_name, p.last_name,
       d.specialty, a.diagnosis, d.first_name AS doctor_first_name
FROM   project_medical_data_history.patients p
JOIN   project_medical_data_history.admissions a
    ON p.patient_id = a.patient_id
JOIN   project_medical_data_history.doctors d
    ON a.attending_doctor_id = d.doctor_id
WHERE  a.diagnosis = 'Epilepsy'
  AND  d.first_name = 'Lisa';
```

---

## 🧰 SQL Techniques Applied

| Technique | Queries |
|---|---|
| SELECT / WHERE / LIKE | Q1–Q5, Q18 |
| BETWEEN / IN | Q4, Q10, Q27 |
| COALESCE() — NULL handling | Q5 |
| CONCAT / UPPER / LOWER | Q6, Q28 |
| YEAR() / DAY() / LENGTH() | Q8, Q16, Q20, Q31 |
| COUNT / SUM / MAX / MIN | Q8, Q11, Q13, Q21, Q30 |
| GROUP BY / HAVING | Q17, Q23, Q24, Q26, Q29, Q32 |
| INNER JOIN (2-table) | Q7, Q19 |
| Multi-table JOIN chain (3-table) | Q34 |
| Subqueries | Q9, Q22 |
| UNION ALL | Q25 |
| CASE WHEN / THEN | Q21, Q33 |
| FLOOR() / POWER() | Q32, Q33 |
| ORDER BY (multi-column) | Q20, Q24, Q28 |
| DISTINCT | Q14, Q16, Q17 |

---

## 📊 Key Outcomes & Insights

- **Same-day discharge cases** identified — flags potential data quality issues or day-procedure patterns in admissions data.
- **Gender distribution analysis** produced across the full patient population using two alternate SQL methods.
- **City-level patient density** mapped to support regional healthcare planning decisions.
- **Chronic condition tracking** enabled by surfacing patients admitted multiple times for the same diagnosis.
- **WHO BMI formula** implemented directly in SQL to generate a computed obesity indicator (`isObese`) from raw height and weight columns.
- **Allergy prevalence ranked** across the patient population — applicable to medication risk stratification.
- **Alternate query approaches** demonstrated for complex problems (e.g., `CASE` vs. subqueries, `ORDER BY LIMIT` vs. `MAX()`) to showcase query optimisation awareness.

---

## 🛠️ Tools & Environment

| Item | Detail |
|---|---|
| Query Language | MySQL (Standard SQL) |
| IDE | MySQL Workbench / DBeaver |
| Functions Used | COALESCE, CONCAT, UPPER, LOWER, YEAR, DAY, LENGTH, COUNT, SUM, MAX, MIN, FLOOR, POWER, CASE WHEN |
| Clauses Applied | SELECT, WHERE, JOIN, GROUP BY, HAVING, ORDER BY, UNION ALL, DISTINCT, LIMIT, IN, BETWEEN, LIKE, IS NULL |

---

## 👤 About the Analyst

**Dharanidharan J** — Data Analyst with a background in sales operations and field training, transitioning into data analytics and business intelligence.

- 🔗 [LinkedIn](https://linkedin.com/in/dharaniddj)
- 💼 Open to Data Analyst / Business Analyst roles (India & Singapore market)

---

*· Medical Data History SQL Project · Dharanidharan J · 2025*
