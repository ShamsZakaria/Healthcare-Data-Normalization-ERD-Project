-- 1. Retrieve names and genders of all patients
SELECT name, gender FROM patients;

-- 2. Patients with blood type O+
SELECT * FROM patients WHERE blood_type = 'O+';

-- 3. Count patients per blood type
SELECT blood_type, COUNT(*) AS total FROM patients GROUP BY blood_type;

-- 4. List all distinct hospital names
SELECT DISTINCT hospital_name FROM hospitals;

-- 5. Order patients by age (descending)
SELECT * FROM patients ORDER BY age DESC;

-- 6. Average billing amount
SELECT AVG(billing_amount) AS average_bill FROM admissions;

-- 7. Emergency admissions
SELECT * FROM admissions WHERE admission_type = 'Emergency';

-- 8. Number of cases per doctor
SELECT doctor_id, COUNT(*) AS cases_handled FROM admissions GROUP BY doctor_id;

-- 9. Doctor and hospital name
SELECT d.name AS doctor_name, h.hospital_name
FROM doctors d
JOIN hospitals h ON d.hospital_id = h.hospital_id;

-- 10. Patients with abnormal test results
SELECT p.name FROM patients p
JOIN admission_testes t ON p.patient_id = t.patient_id
WHERE result = 'Abnormal';

-- 11. Patients treated at 'Cairo Hospital'
SELECT p.name FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN hospitals h ON a.hospital_id = h.hospital_id
WHERE h.hospital_name = 'Cairo Hospital';

-- 12. Total billing per hospital
SELECT h.hospital_name, SUM(a.billing_amount) AS total_billing
FROM admissions a
JOIN hospitals h ON a.hospital_id = h.hospital_id
GROUP BY h.hospital_name;

-- 13. Patients who stayed more than 5 days
SELECT p.name FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE DATEDIFF(day, a.date_of_admission, a.discharge_date) > 5;

-- 14. Medications used per admission
SELECT a.admission_id, m.medication_name
FROM admission_medications m
JOIN admissions a ON m.admission_id = a.admission_id;

-- 15. Number of patients per medical condition
SELECT medical_condition, COUNT(*) AS total_patients
FROM admissions
GROUP BY medical_condition;

-- 16. Number of patients per doctor
SELECT d.name, COUNT(a.patient_id) AS patients_treated
FROM doctors d
JOIN admissions a ON d.doctor_id = a.doctor_id
GROUP BY d.name;

-- 17. Doctors per hospital
SELECT h.hospital_name, COUNT(d.doctor_id) AS doctor_count
FROM doctors d
JOIN hospitals h ON d.hospital_id = h.hospital_id
GROUP BY h.hospital_name;

-- 18. Patients discharged before 2024
SELECT name FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.discharge_date < '2024-01-01';

-- 19. Patients billed above average
SELECT name FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.billing_amount > (
    SELECT AVG(billing_amount) FROM admissions
);

-- 20. Patients who were given 'Aspirin'
SELECT DISTINCT p.name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN admission_medications m ON a.admission_id = m.admission_id
WHERE m.medication_name = 'Aspirin';

-- 21. Patient + doctor + hospital name with COALESCE
SELECT p.name AS patient_name,
       d.name AS doctor_name,
       h.hospital_name,
       COALESCE(a.medical_condition, 'No Diagnosis') AS condition
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN hospitals h ON a.hospital_id = h.hospital_id;

-- 22. Patients admitted more than once
SELECT p.name, COUNT(*) AS num_admissions
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
GROUP BY p.name
HAVING COUNT(*) > 1;

-- 23. Admission types with > 3 entries
SELECT admission_type, COUNT(*) AS total
FROM admissions
WHERE admission_type IS NOT NULL
GROUP BY admission_type
HAVING COUNT(*) > 3;

-- 24. Patients with more than one medical condition
SELECT p.name, COUNT(DISTINCT a.medical_condition) AS condition_count
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
GROUP BY p.name
HAVING COUNT(DISTINCT a.medical_condition) > 1;

-- 25. Hospitals with billing over 50,000
SELECT h.hospital_name, SUM(a.billing_amount) AS total_billing
FROM admissions a
JOIN hospitals h ON a.hospital_id = h.hospital_id
GROUP BY h.hospital_name
HAVING SUM(a.billing_amount) > 50000;

-- 26. CTE: Urgent admissions for patients > 40
WITH UrgentPatients AS (
    SELECT p.name, p.age, d.name AS doctor_name, h.hospital_name
    FROM patients p
    JOIN admissions a ON p.patient_id = a.patient_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
    JOIN hospitals h ON a.hospital_id = h.hospital_id
    WHERE p.age > 40 AND a.admission_type = 'Urgent'
)
SELECT * FROM UrgentPatients;

-- 27. Patients treated by the same doctor as 'Ahmed'
SELECT p2.name
FROM patients p1
JOIN admissions a1 ON p1.patient_id = a1.patient_id
JOIN admissions a2 ON a1.doctor_id = a2.doctor_id
JOIN patients p2 ON a2.patient_id = p2.patient_id
WHERE p1.name = 'Ahmed';

-- 28. Admissions at 'Alex Medical Center' with meds
SELECT p.name, a.admission_id, m.medication_name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN hospitals h ON a.hospital_id = h.hospital_id
JOIN admission_medications m ON a.admission_id = m.admission_id
WHERE h.hospital_name = 'Alex Medical Center';

-- 29. Patients discharged after 10+ days
SELECT p.name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE DATEDIFF(day, a.date_of_admission, a.discharge_date) >= 10;

-- 30. CASE logic: Senior/Adult
SELECT p.name, a.room_number,
       CASE
           WHEN p.age > 50 THEN 'Senior'
           ELSE 'Adult'
       END AS age_group
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.room_number BETWEEN 100 AND 200
  AND d.name = 'Dr. Mona';

-- 31. Number of admissions per insurance provider
SELECT insurance_provider, COUNT(*) AS admission_count
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
GROUP BY insurance_provider;
