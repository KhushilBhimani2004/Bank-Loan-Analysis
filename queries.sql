CREATE DATABASE bankloan;
USE bankloan;
select * from financial_loan ;
-- Month to date is December
--  select count(id) from bankloandat a  ;

-- KPI  Key Performance Indicators requirements;
-- 1) Total Loan Application
SELECT COUNT(ID) AS Total_Applications FROM financial_loan; 

-- 2) MTD Loan Applications 
SELECT COUNT(ID) AS MTD_TOTAL_LOAN_APPLICATIONS FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 2) MoM Loan Applications formula --> {(MTD - PMTD)/PMTD}
SELECT COUNT(ID) AS PMTD_TOTAL_LOAN_APPLICATIONS FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;  

-- 3) Total Funded Amount Month to Date
SELECT SUM(loan_amount) AS MTD_TOTAL_FUNDED_AMOUNT FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous Month to current month (month over month)
SELECT SUM(loan_amount) AS PMTD_TOTAL_FUNDED_AMOUNT FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;


-- 4) Total Amount Received Month to Date
SELECT SUM(total_payment) AS MTD_TOTAL_RECEIVED_AMOUNT FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Total Amount Received Previous Month to current month (month over month)
SELECT SUM(total_payment) AS PMTD_TOTAL_RECEIVED_AMOUNT FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 5) Average Interest Rate 
-- MTD
SELECT ROUND(AVG(int_rate),4)*100 AS MTD_AVERAGE_INTEREST_RATE FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- MoM
SELECT ROUND(AVG(int_rate),4)*100 AS PMTD_AVERAGE_INTEREST_RATE FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 6) Debt to Income ratio - DTI 
-- MTD
SELECT Round(AVG(dti),4) * 100 AS AVERAGE_DTI FROM financial_loan;
SELECT Round(AVG(dti),4)*100 AS MTD_AVERAGE_DTI FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- PMTD
SELECT Round(AVG(dti),4)*100 AS PMTD_AVERAGE_DTI FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 7) type of loan depende on status: fully paid / current (paying) - good loan, charged off (not paying)- bad loan
-- Good Loan Application %
SELECT 
	ROUND((COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'current' THEN id END)*100) 
    /
    COUNT(ID), 2) AS GOOD_LOAN_PERCENTAGE
FROM financial_loan;

-- 8) Good Loan Applications
-- SELECT 
-- (COUNT(CASE WHEN loan_status = 'Fully paid' OR loan_status='current' THEN ID END)) AS GOOD_LOAN_APPLICATIONS 
-- FROM financial_loan;

SELECT  COUNT(id) AS GOOD_LOAN_APPLICATIONS from financial_loan
WHERE loan_status = 'Fully paid' OR loan_status = 'current';


-- GOOD LOAN FUNDED AMOUNT
SELECT  SUM(loan_amount) AS GOOD_LOAN_FUNDED_AMOUNT from financial_loan
WHERE  loan_status IN ('Fully paid', 'current');
-- loan_status = 'Fully paid' OR loan_status = 'current'; 

-- GOOD LOAN TOTAL RECEIVED AMOUNT
SELECT  SUM(total_payment) AS GOOD_LOAN_FUNDED_AMOUNT from financial_loan
WHERE  loan_status IN ('Fully paid', 'current');

-- BAD Loans %
SELECT
	ROUND((COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)*100)
    /
    COUNT(id),2) AS BAD_LOAN_PERCENTAGE 
FROM financial_loan;

-- Total applications of bad loan
SELECT COUNT(id) AS BAD_LOAN_APPLICATIONS FROM financial_loan
WHERE loan_status = 'Charged Off';

-- BAD LOAN FUNDED AMOUNT
SELECT SUM(loan_amount) AS BAD_LOAN_FUNDED_AMOUNT FROM financial_loan
WHERE loan_status = 'Charged Off';

-- BAD LOAN AMOUNT RECEIVED
SELECT SUM(total_payment) AS BAD_LOAN_RECEIVED_AMOUNT FROM financial_loan
WHERE loan_status = 'Charged Off';

-- Loan status gridview
SELECT 
	loan_status AS Loan_Status,
    Count(id) AS Total_Loan_Applications,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate * 100) AS Interest_Rate,
    AVG(dti * 100) AS DTI
FROM financial_loan
GROUP BY loan_status;

-- MTD Loan GridView
SELECT 
	loan_status AS MTD_Loan_Status,
    Count(id) AS MTD_Total_Loan_Applications,
    SUM(total_payment) AS MTD_Total_Amount_Received,
    SUM(loan_amount) AS MTD_Total_Funded_Amount
    -- AVG(int_rate * 100) AS MTD_Interest_Rate,
    -- AVG(dti * 100) AS MTD_DTI
FROM financial_loan
WHERE MONTH(issue_date) = 12
GROUP BY loan_status;

-- PMTD
SELECT 
	loan_status AS PMTD_Loan_Status,
    Count(id) AS PMTD_Total_Loan_Applications,
    SUM(total_payment) AS PMTD_Total_Amount_Received,
    SUM(loan_amount) AS PMTD_Total_Funded_Amount
    -- AVG(int_rate * 100) AS PMTD_Interest_Rate,
    -- AVG(dti * 100) AS PMTD_DTI
FROM financial_loan
WHERE MONTH(issue_date) = 11
GROUP BY loan_status;




-- Overview


-- monthly trend by issue date
SELECT
	MONTH(issue_date) AS MONTH_NUM,
	DATE_FORMAT(issue_date, '%M') AS MONTH_NAME,
    COUNT(id) AS TOTAL_LOAN_APPLICATION,
    SUM(loan_amount) AS TOTAL_AMOUNT_FUNDED,
    SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM financial_loan
GROUP BY MONTH(issue_date), DATE_FORMAT(issue_date, '%M')
ORDER BY MONTH(issue_date);

-- Regional analyiss

SELECT
	address_state AS State, 
    COUNT(id) AS TOTAL_LOAN_APPLICATION,
    SUM(loan_amount) AS TOTAL_AMOUNT_FUNDED,
    SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM financial_loan
GROUP BY State
ORDER BY TOTAL_AMOUNT_FUNDED DESC;

-- Loan Term Analysis

SELECT
	term AS LOAN_TERM, 
    COUNT(id) AS TOTAL_LOAN_APPLICATION,
    SUM(loan_amount) AS TOTAL_AMOUNT_FUNDED,
    SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM financial_loan
GROUP BY LOAN_TERM
ORDER BY LOAN_TERM;


-- employee length
SELECT
	emp_length AS EMPLOYEE_LENGTH, 
    COUNT(id) AS TOTAL_LOAN_APPLICATION,
    SUM(loan_amount) AS TOTAL_AMOUNT_FUNDED,
    SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM financial_loan
GROUP BY EMPLOYEE_LENGTH
ORDER BY COUNT(ID) DESC;

-- PURPOSE

SELECT
	purpose AS PURPOSE, 
    COUNT(id) AS TOTAL_LOAN_APPLICATION,
    SUM(loan_amount) AS TOTAL_AMOUNT_FUNDED,
    SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM financial_loan
GROUP BY purpose
ORDER BY COUNT(ID) DESC;

-- home ownership

SELECT
	home_ownership AS HOME_OWNERSHIP, 
    COUNT(id) AS TOTAL_LOAN_APPLICATION,
    SUM(loan_amount) AS TOTAL_AMOUNT_FUNDED,
    SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM financial_loan
-- WHERE grade = 'A'
GROUP BY home_ownership
ORDER BY COUNT(ID) DESC;
