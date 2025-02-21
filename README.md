# COVID Data Exploration Project  

## 📌 Overview  
This project focuses on analyzing COVID-19 data using SQL. The dataset includes confirmed cases, death rates, and vaccination trends across various countries. The goal is to extract meaningful insights about the pandemic’s impact.  

## 🛠 Tools & Technologies Used  
- **SQL (MySQL/SSMS/SQL Server)** – For data exploration & analysis  
- **Microsoft Excel** – For initial data review  

## 📂 Dataset Details  
- **Source:** (WHO)  
- **Data Includes:**  
  - Total cases, deaths, and recoveries  
  - Vaccination trends by country  
  - Population statistics for comparison  
  - Case fatality rate calculations
**[Download Data Set Used](https://github.com/Durai-Murugan-DA/Covid-data-exploration/tree/e9c23df7643c3c199e139c8117d1ad1018287b85/Covid%20Data%20Set%20Used)**  

## 🔍 Key Insights & Analysis  
### 1️⃣ **COVID-19 Spread & Trends**  
   - Countries with the highest infection rates.  
   - Daily case trends over time.  
   - Growth rate of infections.  

### 2️⃣ **Mortality Analysis**  
   - Case Fatality Rate (CFR) = (Total Deaths / Total Cases) × 100  
   - Countries with the highest death rates.  

### 3️⃣ **Vaccination Impact**  
   - Percentage of population vaccinated.  
   - Relationship between vaccination rates & case reduction.

## 📈 Results & Conclusions
Vaccination significantly reduced the infection rate in most countries.
Countries with early interventions had lower mortality rates.
High population density areas had higher infection spreads.

## 📂 Project File  

📌 [SQL Query File - Covid Data Exploration](https://github.com/Durai-Murugan-DA/Covid-data-exploration/blob/e9c23df7643c3c199e139c8117d1ad1018287b85/Covid%20data%20exploration%20project.sql)  

## About the Author  

👤 **Durai Murugan**  
📧 [duraijeeva2017@gmail.com](mailto:duraijeeva2017@gmail.com)  
🔗 [LinkedIn Profile](https://www.linkedin.com/in/durai-murugan-data-analyst)  
## 📜  Some Sample SQL Queries Used  

```sql
-- Data Cleaning & Formatting  
SELECT * FROM covid_data  
WHERE new_cases IS NOT NULL;  

-- Finding Top 10 Countries by Cases  
SELECT location, SUM(new_cases) AS total_cases  
FROM covid_data  
GROUP BY location  
ORDER BY total_cases DESC  
LIMIT 10;  

-- Calculating Case Fatality Rate (CFR)  
SELECT location, (SUM(total_deaths) / SUM(total_cases)) * 100 AS CFR  
FROM covid_data  
GROUP BY location  
ORDER BY CFR DESC;  
