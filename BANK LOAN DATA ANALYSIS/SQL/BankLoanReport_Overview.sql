
/*---------------------------------------------------------
 File: BankLoanReport_Overview.sql
 Purpose:
 This SQL file generates the data required for the Dashboard 2: 
 Overview section of the Bank Loan Report. It includes queries 
 for visualizations such as monthly trends, regional analysis, 
 loan term distribution, employee length analysis, loan purpose 
 breakdown, and home ownership metrics.
---------------------------------------------------------*/

/*---------------------------------------------------------
 Query 1: Monthly Trends by Issue Date
 Objective:
 Aggregate Total Funded Amount and Total Amount Received 
 by month (based on 'issue_date') to visualize monthly lending 
 trends. Ordered chronologically by month.
 Metrics:
 1. Total Funded Amount
 2. Total Amount Received
---------------------------------------------------------*/
SELECT 
    DATENAME(MONTH, issue_date) AS [MONTH],
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY 
    DATENAME(MONTH, issue_date),
    DATEPART(MONTH, issue_date)
ORDER BY 
    DATEPART(MONTH, issue_date);


/*---------------------------------------------------------
 Query 2: Regional Analysis by State
 Objective:
 Summarize lending metrics by state to support geographic 
 insights. Useful for filled map visualization.
 Metrics:
 1. Total Loan Applications
 2. Total Funded Amount
 3. Total Amount Received
---------------------------------------------------------*/
SELECT 
    address_state,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state;


/*---------------------------------------------------------
 Query 3: Loan Term Analysis
 Objective:
 Aggregate lending metrics by loan term (e.g., 36 months, 
 60 months) to understand distribution and performance.
 Metrics:
 1. Total Loan Applications
 2. Total Funded Amount
 3. Total Amount Received
---------------------------------------------------------*/
SELECT  
    term AS Loan_Term,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term;


/*---------------------------------------------------------
 Query 4: Employee Length Analysis
 Objective:
 Summarize lending metrics based on borrower employment 
 length. Useful for analyzing risk or lending patterns 
 across employment durations.
 Metrics:
 1. Total Loan Applications
 2. Total Funded Amount
 3. Total Amount Received
---------------------------------------------------------*/
SELECT  
    emp_length AS Employee_Length,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) DESC;


/*---------------------------------------------------------
 Query 5: Loan Purpose Breakdown
 Objective:
 Aggregate lending metrics by loan purpose (e.g., debt 
 consolidation, credit card refinancing). Supports bar 
 chart visualization.
 Metrics:
 1. Total Loan Applications
 2. Total Funded Amount
 3. Total Amount Received
---------------------------------------------------------*/
SELECT  
    purpose,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC;


/*---------------------------------------------------------
 Query 6: Home Ownership Analysis
 Objective:
 Aggregate lending metrics by home ownership category 
 (e.g., own, rent, mortgage) for hierarchical treemap 
 visualizations.
 Metrics:
 1. Total Loan Applications
 2. Total Funded Amount
 3. Total Amount Received
---------------------------------------------------------*/
SELECT  
    home_ownership,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;

