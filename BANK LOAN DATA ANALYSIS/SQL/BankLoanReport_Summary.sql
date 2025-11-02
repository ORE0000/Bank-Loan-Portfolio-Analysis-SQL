/*=========================================================
 Project: Bank Loan Report
 File: BankLoanReport_Summary.sql
 Dashboard: Summary
 Author: Ashutosh Pant
 Date: 30/09/2025
 
 Purpose:
 This project provides insights into the bank's lending 
 activities and performance through SQL-based analysis. 
 The queries below are designed to extract and summarize 
 key performance indicators (KPIs), enabling data-driven 
 decision-making.
=========================================================*/


/*---------------------------------------------------------
 Query 1: Extract All Loan Data
 Objective:
 Retrieve the complete dataset from the source table 
 [bank_loan_data]. This serves as the foundation for 
 further calculations, validations, and exploratory analysis.
---------------------------------------------------------*/
SELECT 
    * 
FROM bank_loan_data;


/*---------------------------------------------------------
 Query 2: Calculate Total Loan Applications
 Objective:
 Compute the total number of loan applications recorded 
 in the system by counting the unique loan IDs. This KPI 
 provides a high-level view of the overall loan application 
 volume over the entire dataset.
---------------------------------------------------------*/
SELECT 
    COUNT(id) AS [Total Loan Application]
FROM bank_loan_data;


/*---------------------------------------------------------
 Query 3: Calculate Month-to-Date (MTD) Loan Applications
 Objective:
 Determine the number of loan applications submitted during 
 the specified month (December 2021). This metric tracks 
 short-term lending activity and helps measure progress 
 within the current reporting cycle.
---------------------------------------------------------*/
SELECT 
    COUNT(id) AS [MTD Total Loan Application]
FROM bank_loan_data
WHERE YEAR(issue_date) = 2021
  AND MONTH(issue_date) = (
        SELECT MONTH(MAX(issue_date))
        FROM bank_loan_data
        WHERE YEAR(issue_date) = 2021
    );


/*---------------------------------------------------------
 Query 4: Calculate Previous Month-to-Date (PMTD) Loan Applications
 Objective:
 Determine the total number of loan applications received 
 during the previous month (November 2021). This metric 
 provides a baseline for comparison against the current 
 Month-to-Date (MTD) loan applications.
---------------------------------------------------------*/
SELECT 
    COUNT(id) AS [PMTD Loan Applications]
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 
  AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 5: Calculate Month-over-Month (MoM) Absolute Change
 Objective:
 Measure the absolute difference in the number of loan 
 applications between the current month (December 2021) 
 and the previous month (November 2021). This KPI highlights 
 whether application volumes are increasing or decreasing.
---------------------------------------------------------*/
SELECT 
    ( 
      (SELECT COUNT(id) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021) 
      -
      (SELECT COUNT(id) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
    ) AS [MoM Change in Applications];


/*---------------------------------------------------------
 Query 6: Calculate Month-over-Month (MoM) Percentage Change
 Objective:
 Compute the percentage change in loan applications between 
 the current month (December 2021) and the previous month 
 (November 2021). This relative KPI provides deeper insight 
 into the growth or decline trend, normalized against the 
 previous month’s application volume.
 
 Note:
 The NULLIF function prevents division-by-zero errors when 
 the previous month’s application count is zero.
---------------------------------------------------------*/
SELECT 
    ROUND(CAST((
      (SELECT COUNT(id) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021) 
      -
      (SELECT COUNT(id) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
    ) AS FLOAT)
/ NULLIF(
      (SELECT COUNT(id) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021), 0
    ) * 100,2) AS [MoM % Change in Applications];



/*---------------------------------------------------------
 Query 7: Calculate Total Funded Amount
 Objective:
 Compute the total sum of funds disbursed as loans across 
 the entire dataset. This KPI provides an overview of the 
 bank's lending volume in monetary terms.
---------------------------------------------------------*/
SELECT 
    SUM(loan_amount) AS [Total Funded Amount]
FROM bank_loan_data;


/*---------------------------------------------------------
 Query 8: Calculate Month-to-Date (MTD) Total Funded Amount
 Objective:
 Determine the total sum of loan funds disbursed in the 
 current month (December 2021). This metric helps track 
 short-term lending activity and supports month-over-month 
 performance analysis.
---------------------------------------------------------*/
SELECT 
    SUM(loan_amount) AS [MTD Total Funded Amount]
FROM bank_loan_data 
WHERE MONTH(issue_date) = 12
      AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 9: Calculate Previous Month-to-Date (PMTD) Total Funded Amount
 Objective:
 Determine the total sum of loan funds disbursed in the 
 previous month (November 2021). This serves as a baseline 
 for month-over-month comparison of funded amounts.
---------------------------------------------------------*/
SELECT 
    SUM(loan_amount) AS [PMTD Total Funded Amount]
FROM bank_loan_data 
WHERE MONTH(issue_date) = 11
      AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 10: Calculate Month-over-Month (MoM) Absolute Change in Funded Amount
 Objective:
 Measure the absolute difference in total funded amounts 
 between the current month (December 2021) and the previous 
 month (November 2021). This KPI identifies increases or 
 decreases in lending volume.
---------------------------------------------------------*/
SELECT 
    ( 
      (SELECT SUM(loan_amount) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021) 
      -
      (SELECT SUM(loan_amount)
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
    ) AS [MoM Total Funded Amount];


/*---------------------------------------------------------
 Query 11: Calculate Month-over-Month (MoM) Percentage Change in Funded Amount
 Objective:
 Compute the percentage change in total funded amounts 
 between the current month (December 2021) and the previous 
 month (November 2021). This relative KPI highlights the 
 growth or decline in disbursed funds.
 
 Note:
 The NULLIF function prevents division-by-zero errors if the 
 previous month’s funded amount is zero.
---------------------------------------------------------*/
SELECT 
    ROUND(CAST(( 
      (SELECT SUM(loan_amount) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021) 
      -
      (SELECT SUM(loan_amount) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
    ) AS FLOAT)
/ NULLIF(
      (SELECT SUM(loan_amount)
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021), 0
    ) * 100,2) AS [MoM % Total Funded Amount];



/*---------------------------------------------------------
 Query 12: Calculate Total Amount Received
 Objective:
 Compute the total sum of payments received from borrowers 
 across all loans. This KPI provides an overview of cash 
 inflows from the bank's lending operations.
---------------------------------------------------------*/
SELECT 
    SUM(total_payment) AS [Total Amount Received]
FROM bank_loan_data;


/*---------------------------------------------------------
 Query 13: Calculate Month-to-Date (MTD) Total Amount Received
 Objective:
 Determine the total sum of payments received during the 
 current month (December 2021). This metric helps track 
 short-term cash inflow and supports month-over-month 
 performance analysis.
---------------------------------------------------------*/
SELECT 
    SUM(total_payment) AS [MTD Total Amount Received]
FROM bank_loan_data 
WHERE MONTH(issue_date) = 12
      AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 14: Calculate Previous Month-to-Date (PMTD) Total Amount Received
 Objective:
 Determine the total sum of payments received during the 
 previous month (November 2021). This serves as a baseline 
 for month-over-month comparison of received amounts.
---------------------------------------------------------*/
SELECT 
    SUM(total_payment) AS [PMTD Total Amount Received]
FROM bank_loan_data 
WHERE MONTH(issue_date) = 11
      AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 15: Calculate Month-over-Month (MoM) Absolute Change in Amount Received
 Objective:
 Measure the absolute difference in total payments received 
 between the current month (December 2021) and the previous 
 month (November 2021). This KPI identifies increases or 
 decreases in cash inflows from lending.
---------------------------------------------------------*/
SELECT 
    ( 
      (SELECT SUM(total_payment) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021) 
      -
      (SELECT SUM(total_payment)
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
    ) AS [MoM Total Amount Received];


/*---------------------------------------------------------
 Query 16: Calculate Month-over-Month (MoM) Percentage Change in Amount Received
 Objective:
 Compute the percentage change in total payments received 
 between the current month (December 2021) and the previous 
 month (November 2021). This relative KPI highlights trends 
 in cash inflow growth or decline.
 
 Note:
 The NULLIF function prevents division-by-zero errors if the 
 previous month’s total received amount is zero.
---------------------------------------------------------*/
SELECT 
    ROUND(CAST(( 
      (SELECT SUM(total_payment) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021) 
      -
      (SELECT SUM(total_payment) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
    ) AS FLOAT)
/ NULLIF(
      (SELECT SUM(total_payment)
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021), 0
    ) * 100,2) AS [MoM % Total Amount Received];


/*---------------------------------------------------------
 Query 17: Calculate Average Interest Rate
 Objective:
 Compute the average interest rate across all loans in the 
 dataset. This KPI provides insights into the overall cost 
 of the bank's lending portfolio and helps assess pricing 
 strategies.

 Note:
 The interest rate is multiplied by 100 and rounded to two 
 decimal places for readability and reporting consistency.
---------------------------------------------------------*/
SELECT 
    ROUND((AVG(int_rate) * 100),2) AS [Average Interest Rate]
FROM bank_loan_data;


/*---------------------------------------------------------
 Query 18: Calculate Month-to-Date (MTD) Average Interest Rate
 Objective:
 Determine the average interest rate for loans issued in 
 the current month (December 2021). This helps monitor 
 short-term trends and supports month-over-month (MoM) 
 performance analysis.
---------------------------------------------------------*/
SELECT 
    ROUND((AVG(int_rate) * 100),2) AS [MTD Average Interest Rate]
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
      AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 19: Calculate Previous Month-to-Date (PMTD) Average Interest Rate
 Objective:
 Determine the average interest rate for loans issued in 
 the previous month (November 2021). This serves as a 
 baseline for month-over-month (MoM) comparisons.
---------------------------------------------------------*/
SELECT 
    ROUND((AVG(int_rate) * 100),2) AS [PMTD Average Interest Rate]
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
      AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 20: Calculate Month-over-Month (MoM) Absolute Change in Average Interest Rate
 Objective:
 Measure the absolute difference in average interest rates 
 between the current month (December 2021) and the previous 
 month (November 2021). This helps identify changes in 
 lending costs over time.
---------------------------------------------------------*/
SELECT 
    ROUND((
      (SELECT AVG(int_rate) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021)
      -
      (SELECT AVG(int_rate)
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
    ) * 100,2) AS [MoM Change in Average Interest Rate];


/*---------------------------------------------------------
 Query 21: Calculate Month-over-Month (MoM) Percentage Change in Average Interest Rate
 Objective:
 Compute the percentage change in average interest rates 
 between the current month (December 2021) and the previous 
 month (November 2021). This KPI highlights relative 
 variations in lending costs over time.

 Note:
 The NULLIF function prevents division-by-zero errors if the 
 previous month’s average interest rate is zero.
---------------------------------------------------------*/
SELECT 
    ROUND(
      CAST(
        (
          (SELECT AVG(int_rate) 
           FROM bank_loan_data 
           WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021)
          -
          (SELECT AVG(int_rate)
           FROM bank_loan_data 
           WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
        ) AS FLOAT
      )
      / NULLIF(
          (SELECT AVG(int_rate) 
           FROM bank_loan_data 
           WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021), 0
        ) * 100, 2
    ) AS [MoM % Change in Average Interest Rate];



/*---------------------------------------------------------
 Query 22: Calculate Average Debt-to-Income Ratio (DTI)
 Objective:
 Compute the average Debt-to-Income (DTI) ratio across all 
 borrowers. This KPI provides insights into borrowers' 
 financial health and the overall risk profile of the bank's 
 lending portfolio.

 Note:
 The DTI is multiplied by 100 and rounded to two decimal 
 places for reporting consistency.
---------------------------------------------------------*/
SELECT 
    ROUND((AVG(dti) * 100),2) AS [Average Debt-to-Income Ratio (DTI)]
FROM bank_loan_data;


/*---------------------------------------------------------
 Query 23: Calculate Month-to-Date (MTD) Average DTI
 Objective:
 Determine the average DTI for loans issued in the current 
 month (December 2021). This metric helps monitor short-term 
 changes in borrower risk profiles.
---------------------------------------------------------*/
SELECT 
    ROUND((AVG(dti) * 100),2) AS [MTD Average Debt-to-Income Ratio (DTI)]
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
      AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 24: Calculate Previous Month-to-Date (PMTD) Average DTI
 Objective:
 Determine the average DTI for loans issued in the previous 
 month (November 2021). This serves as a baseline for 
 month-over-month comparisons.
---------------------------------------------------------*/
SELECT 
    ROUND((AVG(dti) * 100),2) AS [PMTD Average Debt-to-Income Ratio (DTI)]
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 
      AND YEAR(issue_date) = 2021;


/*---------------------------------------------------------
 Query 25: Calculate Month-over-Month (MoM) Absolute Change in Average DTI
 Objective:
 Measure the absolute difference in average DTI between the 
 current month (December 2021) and the previous month 
 (November 2021). This helps identify shifts in borrower 
 risk over time.
---------------------------------------------------------*/
SELECT 
    ROUND((
      (SELECT AVG(dti) 
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021)
      -
      (SELECT AVG(dti)
       FROM bank_loan_data 
       WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
    ) * 100,2) AS [MoM Change in Average Debt-to-Income Ratio (DTI)];


/*---------------------------------------------------------
 Query 26: Calculate Month-over-Month (MoM) Percentage Change in Average DTI
 Objective:
 Compute the percentage change in average DTI between the 
 current month (December 2021) and the previous month 
 (November 2021). This relative KPI highlights trends in 
 borrower debt risk over time.

 Note:
 The NULLIF function prevents division-by-zero errors if the 
 previous month’s average DTI is zero.
---------------------------------------------------------*/
SELECT 
    ROUND(
      CAST(
        (
          (SELECT AVG(dti) 
           FROM bank_loan_data 
           WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021)
          -
          (SELECT AVG(dti)
           FROM bank_loan_data 
           WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)
        ) AS FLOAT
      )
      / NULLIF(
          (SELECT AVG(dti) 
           FROM bank_loan_data 
           WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021), 0
        ) * 100, 2
    ) AS [MoM % Change in Average Debt-to-Income Ratio (DTI)];





/*---------------------------------------------------------
 Query 27: Count of Loans by Status
 Objective:
 Provide a breakdown of the number of loans by their 
 respective statuses (e.g., Fully Paid, Current, Charged Off). 
 This serves as the foundation for calculating Good vs Bad Loan 
 KPIs and understanding the distribution of loan performance.
---------------------------------------------------------*/
SELECT 
    loan_status,
    COUNT(*) AS loan_status_count
FROM bank_loan_data
GROUP BY loan_status;


/*---------------------------------------------------------
 Query 28: Calculate Good Loan Application Percentage
 Objective:
 Compute the percentage of loan applications classified as 
 'Good Loans'. Good Loans are defined as loans with a status 
 of 'Fully Paid' or 'Current'. This KPI evaluates the quality 
 of the loan portfolio.
---------------------------------------------------------*/
SELECT 
    (COUNT(CASE
                WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id 
           END) * 100)
      /
      COUNT(id) AS [Good Loan Application %]
FROM bank_loan_data;


/*---------------------------------------------------------
 Query 29: Calculate Total Good Loan Applications
 Objective:
 Count the total number of loan applications that fall under 
 the 'Good Loan' category (status = 'Fully Paid' or 'Current'). 
 This KPI helps quantify the volume of high-quality loans.
---------------------------------------------------------*/
SELECT 
    COUNT(*) AS [Total Good Loan Applications]
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';


/*---------------------------------------------------------
 Query 30: Calculate Good Loan Funded Amount
 Objective:
 Compute the total loan amount funded for 'Good Loans' 
 (status = 'Fully Paid' or 'Current'). This KPI provides 
 insights into the disbursed amount that is performing well 
 within the bank's portfolio.
---------------------------------------------------------*/
SELECT 
    SUM(loan_amount) AS [Good Loan Funded Amount]
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';


/*---------------------------------------------------------
 Query 31: Calculate Good Loan Total Received Amount
 Objective:
 Compute the total payments received from 'Good Loans' 
 (status = 'Fully Paid' or 'Current'). This KPI reflects the 
 cash inflow from high-quality loans and indicates the 
 repayment performance of the good loan segment.
---------------------------------------------------------*/
SELECT 
    SUM(total_payment) AS [Good Loan Total Received Amount]
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';


/*---------------------------------------------------------
 Query 32: Calculate Bad Loan Application Percentage
 Objective:
 Compute the percentage of loan applications classified as 
 'Bad Loans'. Bad Loans are defined as loans with a status of 
 'Charged Off'. This KPI evaluates the risk and quality of the 
 loan portfolio.
---------------------------------------------------------*/
SELECT 
    (COUNT(CASE
                WHEN loan_status = 'Charged Off' THEN id 
           END) * 100)
      /
      COUNT(id) AS [Bad Loan Application %]
FROM bank_loan_data;


/*---------------------------------------------------------
 Query 33: Calculate Total Bad Loan Applications
 Objective:
 Count the total number of loan applications that fall under 
 the 'Bad Loan' category (status = 'Charged Off'). This KPI 
 quantifies the volume of high-risk or non-performing loans.
---------------------------------------------------------*/
SELECT 
    COUNT(*) AS [Total Bad Loan Applications]
FROM bank_loan_data
WHERE loan_status = 'Charged Off';


/*---------------------------------------------------------
 Query 34: Calculate Bad Loan Funded Amount
 Objective:
 Compute the total loan amount funded for 'Bad Loans' 
 (status = 'Charged Off'). This KPI provides insights into 
 the disbursed amount that has become non-performing or at 
 risk, helping assess portfolio risk exposure.
---------------------------------------------------------*/
SELECT 
    SUM(loan_amount) AS [Bad Loan Funded Amount]
FROM bank_loan_data
WHERE loan_status = 'Charged Off';


/*---------------------------------------------------------
 Query 35: Calculate Bad Loan Total Received Amount
 Objective:
 Compute the total payments received from 'Bad Loans' 
 (status = 'Charged Off'). This KPI reflects the cash inflow 
 collected from loans that are at risk or have been charged 
 off, providing insight into recovery performance.
---------------------------------------------------------*/
SELECT 
    SUM(total_payment) AS [Bad Loan Total Received Amount]
FROM bank_loan_data
WHERE loan_status = 'Charged Off';


/*---------------------------------------------------------
 Query 36: Loan Status Grid View – Overall Metrics
 Objective:
 Generate a consolidated view of loan portfolio metrics 
 grouped by loan status. This query provides a high-level 
 summary of performance indicators for each loan category 
 (e.g., Fully Paid, Current, Charged Off).

 Metrics Calculated:
 1. Total Loan Applications – Number of loans per status
 2. Total Funded Amount – Sum of loan amounts per status
 3. Total Amount Received – Sum of payments received per status
 4. Average Interest Rate – Average interest rate per status
 5. Average Debt-to-Income Ratio (DTI) – Average DTI per status

 Purpose:
 This query forms the foundation for the Loan Status Grid 
 in the dashboard, enabling assessment of portfolio health 
 and loan quality at a glance.
---------------------------------------------------------*/
SELECT
    loan_status,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received,
    ROUND(AVG(int_rate *100),2) AS Average_Interest_Rate,
    ROUND(AVG(dti *100),2) AS [Average Debt-to-Income Ratio (DTI)]
FROM bank_loan_data
GROUP BY loan_status;


/*---------------------------------------------------------
 Query 37: Loan Status Grid View – Month-to-Date (MTD) Metrics
 Objective:
 Generate a Month-to-Date summary of loan portfolio metrics 
 grouped by loan status. This query focuses on loans issued 
 in the current month (December 2021) to monitor short-term 
 lending performance.

 Metrics Calculated:
 1. MTD Total Funded Amount – Sum of loan amounts issued this month
 2. MTD Total Amount Received – Sum of payments received this month

 Purpose:
 Supports month-over-month comparisons and provides a 
 snapshot of current month lending activity by loan status.
---------------------------------------------------------*/
SELECT 
    loan_status,
    SUM(loan_amount) AS MTD_Total_Funded_Amount,
    SUM(total_payment) AS MTD_Total_Amount_Received
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
      AND YEAR(issue_date) = 2021
GROUP BY loan_status;





