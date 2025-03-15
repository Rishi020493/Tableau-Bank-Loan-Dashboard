/*
-- Created a table by importing a csv file.

-- checking data using SELECT statement.
SELECT * FROM bank_loan.loan;

-- count of total rows
SELECT count(*) FROM bank_loan.loan;

-- Total rows
#38576

-- All the dates columns are in text format we will convert them to the date 

-- Creating new column with date format
-- issue_date
ALTER TABLE bank_loan.loan
ADD COLUMN con_issue_date DATE;

-- Adding data to the new date column
UPDATE bank_loan.loan
SET con_issue_date = CASE WHEN issue_date LIKE '__/__/____' THEN str_to_date(issue_date, '%d/%m/%Y') -- DD/MM/YYYY
WHEN issue_date LIKE '__-__-____' THEN str_to_date(issue_date, '%d-%m-%Y') -- DD-MM-YYYY
WHEN issue_date LIKE '____-__-__-' THEN str_to_date(issue_date, '%Y,%m,%d') -- YYYY-MM-DD
ELSE NULL
END;

-- Droping origional column
ALTER TABLE bank_loan.loan
DROP COLUMN issue_date;

-- Chaging name of newly created column back to the origional
ALTER TABLE bank_loan.loan
CHANGE COLUMN con_issue_date issue_date DATE;



-- last_credit_pull_date
ALTER TABLE bank_loan.loan
ADD COLUMN con_last_credit_pull_date DATE;

-- Adding data to the new date column
UPDATE bank_loan.loan
SET con_last_credit_pull_date = CASE WHEN last_credit_pull_date LIKE '__/__/____' THEN str_to_date(last_credit_pull_date, '%d/%m/%Y') -- DD/MM/YYYY
WHEN last_credit_pull_date LIKE '__-__-____' THEN str_to_date(last_credit_pull_date, '%d-%m-%Y') -- DD-MM-YYYY
WHEN last_credit_pull_date LIKE '____-__-__-' THEN str_to_date(last_credit_pull_date, '%Y,%m,%d') -- YYYY-MM-DD
ELSE NULL
END;

-- Droping origional column
ALTER TABLE bank_loan.loan
DROP COLUMN last_credit_pull_date;

-- Chaging name of newly created column back to the origional
ALTER TABLE bank_loan.loan
CHANGE COLUMN con_last_credit_pull_date last_credit_pull_date DATE;


-- next_payment_date
ALTER TABLE bank_loan.loan
ADD COLUMN con_next_payment_date DATE;

-- Adding data to the new date column
UPDATE bank_loan.loan
SET con_next_payment_date = CASE WHEN next_payment_date LIKE '__/__/____' THEN str_to_date(next_payment_date, '%d/%m/%Y') -- DD/MM/YYYY
WHEN next_payment_date LIKE '__-__-____' THEN str_to_date(next_payment_date, '%d-%m-%Y') -- DD-MM-YYYY
WHEN next_payment_date LIKE '____-__-__-' THEN str_to_date(next_payment_date, '%Y,%m,%d') -- YYYY-MM-DD
ELSE NULL
END;

-- Droping origional column
ALTER TABLE bank_loan.loan
DROP COLUMN next_payment_date;

-- Chaging name of newly created column back to the origional
ALTER TABLE bank_loan.loan
CHANGE COLUMN con_next_payment_date next_payment_date DATE;

-- last_payment_date
ALTER TABLE bank_loan.loan
ADD COLUMN con_last_payment_date DATE;

-- Adding data to the new date column
UPDATE bank_loan.loan
SET con_last_payment_date = CASE WHEN last_payment_date LIKE '__/__/____' THEN str_to_date(last_payment_date, '%d/%m/%Y') -- DD/MM/YYYY
WHEN last_payment_date LIKE '__-__-____' THEN str_to_date(last_payment_date, '%d-%m-%Y') -- DD-MM-YYYY
WHEN last_payment_date LIKE '____-__-__-' THEN str_to_date(last_payment_date, '%Y,%m,%d') -- YYYY-MM-DD
ELSE NULL
END;

-- Droping origional column
ALTER TABLE bank_loan.loan
DROP COLUMN last_payment_date;

-- Chaging name of newly created column back to the origional
ALTER TABLE bank_loan.loan
CHANGE COLUMN con_last_payment_date last_payment_date DATE;
*/

-- Total Applications
SELECT count(id) FROM bank_loan.loan; -- ## 38576

-- max issue_date
SELECT max(issue_date) FROM bank_loan.loan; -- ## 2021-12-12

-- MTD total applications assuming currenct date as 2021-12-12 -- ## 4314
SELECT count(id) FROM bank_loan.loan
WHERE month(issue_date) = 12 and year(issue_date) = 2021;

-- PMTD total applications assuming currenct date as 2021-12-12 -- ## 4035
SELECT count(id) FROM bank_loan.loan
WHERE month(issue_date) = 11 and year(issue_date) = 2021; 


-- Calculating MOM of total loan applications -- ## 6.91%

WITH mtd_app AS ( SELECT count(id) AS Total_MTD_Application FROM bank_loan.loan
WHERE month(issue_date) = 12 and year(issue_date) = 2021), -- ## 4314
pmtd_app AS (SELECT count(id) AS Total_PMTD_Application FROM bank_loan.loan
WHERE month(issue_date) = 11 and year(issue_date) = 2021)-- ## 4035

SELECT ROUND(((mtd_app.Total_MTD_Application - pmtd_app.Total_PMTD_Application)/pmtd_app.Total_PMTD_Application)*100,2) AS mom_loan_application
FROM mtd_app, pmtd_app;

-- TOTAL AMOUNT FUNDED
-- calculating total funded amount -- ## 435757075
SELECT SUM(loan_amount) as TOTAL_FUNDED_AMOUNT FROM bank_loan.loan; 

-- calculating MTD total funded amount assuming currenct date as 2021-12-12 -- ## 53981425
SELECT SUM(loan_amount) as TOTAL_FUNDED_AMOUNT FROM bank_loan.loan
WHERE month(issue_date) = 12 and year(issue_date) = 2021;

-- calculating PMTD total funded amount assuming currenct date as 2021-12-12 -- ## 47754825
SELECT SUM(loan_amount) as TOTAL_FUNDED_AMOUNT FROM bank_loan.loan
WHERE month(issue_date) = 11 and year(issue_date) = 2021;

-- Calculating MOM of total loan_amount -- ## 13.04%
WITH mtd_la AS ( SELECT SUM(loan_amount) as TOTAL_FUNDED_AMOUNT FROM bank_loan.loan
WHERE month(issue_date) = 12 and year(issue_date) = 2021), -- ## 4314
pmtd_la AS (SELECT SUM(loan_amount) as TOTAL_FUNDED_AMOUNT FROM bank_loan.loan
WHERE month(issue_date) = 11 and year(issue_date) = 2021)-- ## 4035

SELECT ROUND(((mtd_la.TOTAL_FUNDED_AMOUNT - pmtd_la.TOTAL_FUNDED_AMOUNT)/pmtd_la.TOTAL_FUNDED_AMOUNT)*100,2) AS mom_loan_application
FROM mtd_la, pmtd_la;

-- TOTAL AMOUNT RECIENVED

-- calculating total amount recienved -- ## 473070933
SELECT SUM(total_payment) as TOTAL_AMOUNT_RECIENVED FROM bank_loan.loan; 

-- calculating MTD total amount recienved assuming currenct date as 2021-12-12 -- ## 58074380
SELECT SUM(total_payment) as TOTAL_AMOUNT_RECIENVED FROM bank_loan.loan
WHERE month(issue_date) = 12 and year(issue_date) = 2021;

-- calculating PMTD total amount recienved assuming currenct date as 2021-12-12 -- ## 50132030
SELECT SUM(total_payment) as TOTAL_AMOUNT_RECIENVED FROM bank_loan.loan
WHERE month(issue_date) = 11 and year(issue_date) = 2021;

-- Calculating MOM of total loan_amount -- ## 15.84%
WITH mtd_payment AS (
    SELECT 
        home_ownership, 
        SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED 
    FROM bank_loan.loan
    WHERE MONTH(issue_date) = 12 
      AND YEAR(issue_date) = 2021 
    GROUP BY home_ownership
),  
pmtd_payment AS (
    SELECT 
        home_ownership, 
        SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED 
    FROM bank_loan.loan
    WHERE MONTH(issue_date) = 11 
      AND YEAR(issue_date) = 2021 
    GROUP BY home_ownership
)  


SELECT 
    mtd_payment.home_ownership, 
    ROUND(
        ((mtd_payment.TOTAL_AMOUNT_RECEIVED - pmtd_payment.TOTAL_AMOUNT_RECEIVED) / pmtd_payment.TOTAL_AMOUNT_RECEIVED) * 100, 2
    ) AS mom_loan_application  
FROM mtd_payment  
JOIN pmtd_payment  
ON mtd_payment.home_ownership = pmtd_payment.home_ownership;

-- Calculating Average interest rate
select avg(int_rate)*100 from bank_loan.loan; -- '12.048831397760178'


-- Calculating the MTD avg int rate 
with a11 as (select round(avg(int_rate)*100,2) as MTD_AVG  from bank_loan.loan
where month(issue_date) = 11 and year(issue_date) = 2021) , -- 11.94

a12 as (
select round(avg(int_rate)*100,2) as MTD_AVG from bank_loan.loan
where month(issue_date) = 12 and year(issue_date) = 2021 )

select (a12.MTD_AVG - a11.MTD_AVG ) *100.0 / a11.MTD_AVG as MOM_AVG from a11, a12; -- 3.517587939698492


-- Calculating the AVG Debt to income ratio (DTI)
select round(avg(dti)*100,2) as MTD_AVG_DTI from bank_loan.loan; -- '13.33'

-- Calculating the AVG Debt to income ratio (DTI) MOM
with a11 as (select round(avg(dti)*100,2) as MTD_AVG_DTI from bank_loan.loan 
where month(issue_date) = 11 and year(issue_date) = 2021 ),

a12 as (select round(avg(dti)*100,2) as MTD_AVG_DTI from bank_loan.loan 
where month(issue_date) = 12 and year(issue_date) = 2021 )

select (a12.MTD_AVG_DTI - a11.MTD_AVG_DTI ) *100.0 / a11.MTD_AVG_DTI as MOM_AVG_DTI from a11, a12; -- 2.7819548872180393

-- Good Loan Application Percentage

select count(case when loan_status= 'Fully Paid' or loan_status= 'Current' then id end)*100.0/
count(id) as Good_Loan_PCT  from bank_loan.loan; -- 86.17

-- Calculate total good loan application

select count(id) as Good_Loan_count
from bank_loan.loan
where loan_status in ('Fully Paid', 'Current'); -- 33243

-- Calculating the total good loan funded amount
select sum(loan_amount) as Good_Loan_Funded
from bank_loan.loan
where loan_status in ('Fully Paid', 'Current'); -- 370224850

-- Good Loan Redcieved Amount
select sum(total_payment) as Good_Loan_Funded
from bank_loan.loan
where loan_status in ('Fully Paid', 'Current'); -- 435786170


-- Bad Loan Application Percentage

select count(case when loan_status = 'Charged Off' then id end)*100 / count(id) as Bad_loan_PCT from bank_loan.loan; -- 13.8247

-- -- Calculate total bad loan application

select count(id) from bank_loan.loan
where loan_status = 'Charged Off'; -- 5333

-- Calculate bad loan funded amount

-- select * from bank_loan.loan

select sum(loan_amount) as 'Total Funded Amount'
from  bank_loan.loan
where loan_status = 'Charged Off'; -- 65532225

-- Calculate bad loan amount recienved
select sum(total_payment) as Bad_Loan_Funded
from bank_loan.loan
where loan_status = 'Charged Off'; -- 37284763

-- Calculate Overview of the Bank by Loan_status

select loan_status, 
count(id) as 'Total Loan Applications',
sum(loan_amount) as 'Total Funded Amount',
sum(total_payment) as 'Total Amount Received)',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as 'MTD Funded Amount',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as 'MTD Amount Received',
avg(int_rate) as 'Average Interest Rate',
avg(dti) as 'Average DTI'
from bank_loan.loan
group by  loan_status;
/*
Charged Off	5333	65532225	37284763	8732775	5324211	0.13878574910931935	0.140047327957998
Fully Paid	32145	351358350	411586256	41302025	47815851	0.11641070773059622	0.13167350754394155
Current	1098	18866500	24199914	3946625	4934318	0.1509932604735884	0.14724344262295075    */

-- Calculate Overview of the Bank by Month
select concat(date_format(issue_date, '%b'),'-', cast(year(issue_date) as CHAR)) as Month,
count(id) as 'Total Loan Applications',
sum(loan_amount) as 'Total Funded Amount',
sum(total_payment) as 'Total Amount Received',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as 'MTD Funded Amount',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as 'MTD Amount Received',
round(avg(int_rate),2) as 'Average Interest Rate',
round(avg(dti),2) as 'Average DTI'
from bank_loan.loan
group by 1
order by 1;

-- Calculate Overview of the Bank by State

select address_state as State,
count(id) as 'Total Loan Applications',
sum(loan_amount) as 'Total Funded Amount',
sum(total_payment) as 'Total Amount Received',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as 'MTD Funded Amount',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as 'MTD Amount Received',
round(avg(int_rate),2) as 'Average Interest Rate',
round(avg(dti),2) as 'Average DTI'
from bank_loan.loan
group by 1
order by 1;

-- Calculate Overview of the Bank by Application_type
select Application_type ,
count(id) as 'Total Loan Applications',
sum(loan_amount) as 'Total Funded Amount',
sum(total_payment) as 'Total Amount Received',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as 'MTD Funded Amount',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as 'MTD Amount Received',
round(avg(int_rate),2) as 'Average Interest Rate',
round(avg(dti),2) as 'Average DTI'
from bank_loan.loan
group by 1
order by 1;

-- Calculate Overview of the Bank by home_ownership
select home_ownership ,
count(id) as 'Total Loan Applications',
sum(loan_amount) as 'Total Funded Amount',
sum(total_payment) as 'Total Amount Received',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as 'MTD Funded Amount',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as 'MTD Amount Received',
round(avg(int_rate),2) as 'Average Interest Rate',
round(avg(dti),2) as 'Average DTI'
from bank_loan.loan
group by 1
order by 1;

-- Calculate Overview of the Bank by purpose
select purpose ,
count(id) as 'Total Loan Applications',
sum(loan_amount) as 'Total Funded Amount',
sum(total_payment) as 'Total Amount Received',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as 'MTD Funded Amount',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as 'MTD Amount Received',
round(avg(int_rate),2) as 'Average Interest Rate',
round(avg(dti),2) as 'Average DTI'
from bank_loan.loan
group by 1
order by 1;

-- Calculate Overview of the Bank by term
select Term ,
count(id) as 'Total Loan Applications',
sum(loan_amount) as 'Total Funded Amount',
sum(total_payment) as 'Total Amount Received',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as 'MTD Funded Amount',
sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as 'MTD Amount Received',
round(avg(int_rate),2) as 'Average Interest Rate',
round(avg(dti),2) as 'Average DTI'
from bank_loan.loan
group by 1
order by 1;



