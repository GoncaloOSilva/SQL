/* Create database */
CREATE DATABASE COVID_Portfolio;
GO

/* Change to the COVID_Portfolio database */
USE COVID_Portfolio;
GO

/* DROP covid_deaths IF NEEDED */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[covid_deaths]') AND type in (N'U'))
DROP TABLE [dbo].[covid_deaths]
GO

/* DROP covid_vaccination IF NEEDED */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[covid_vaccination]') AND type in (N'U'))
DROP TABLE [dbo].[covid_vaccination]
GO

/* TO CREATE AND LOAD DATA INTO covid_deaths AND covid_vaccination
I USED WIZARD, BUT YOU CAN UNCOMMENT THE FOLLOWING QUERIES*/

/* Create covid_death Table */
/*
CREATE TABLE [dbo].[covid_deaths]
(
iso_code VARCHAR(MAX) NULL,
continent VARCHAR(MAX) NULL,
location VARCHAR(MAX) NULL,
date VARCHAR(MAX) NULL,
population VARCHAR(MAX) NULL,
total_cases VARCHAR(MAX) NULL,
new_cases VARCHAR(MAX) NULL,
new_cases_smoothed VARCHAR(MAX) NULL,
total_deaths VARCHAR(MAX) NULL,
new_deaths VARCHAR(MAX) NULL,
new_deaths_smoothed VARCHAR(MAX) NULL,
total_cases_per_million VARCHAR(MAX) NULL,
new_cases_per_million VARCHAR(MAX) NULL,
new_cases_smoothed_per_million VARCHAR(MAX) NULL,
total_deaths_per_million VARCHAR(MAX) NULL,
new_deaths_per_million VARCHAR(MAX) NULL,
new_deaths_smoothed_per_million VARCHAR(MAX) NULL,
reproduction_rate VARCHAR(MAX) NULL,
icu_patients VARCHAR(MAX) NULL,
icu_patients_per_million VARCHAR(MAX) NULL,
hosp_patients VARCHAR(MAX) NULL,
hosp_patients_per_million VARCHAR(MAX) NULL,
weekly_icu_admissions VARCHAR(MAX) NULL,
weekly_icu_admissions_per_million VARCHAR(MAX) NULL,
weekly_hosp_admissions VARCHAR(MAX) NULL,
weekly_hosp_admissions_per_million VARCHAR(MAX) NULL
);
*/

/* Create covid_vaccination Table */
/*
CREATE TABLE [dbo].[covid_vaccination]
(
iso_code VARCHAR(MAX) NULL,
continent VARCHAR(MAX) NULL,
location VARCHAR(MAX) NULL,
date VARCHAR(MAX) NULL,
new_tests VARCHAR(MAX) NULL,
total_tests VARCHAR(MAX) NULL,
total_tests_per_thousand VARCHAR(MAX) NULL,
new_tests_per_thousand VARCHAR(MAX) NULL,
new_tests_smoothed VARCHAR(MAX) NULL,
new_tests_smoothed_per_thousand VARCHAR(MAX) NULL,
positive_rate VARCHAR(MAX) NULL,
tests_per_case VARCHAR(MAX) NULL,
tests_units VARCHAR(MAX) NULL,
total_vaccinations VARCHAR(MAX) NULL,
people_vaccinated VARCHAR(MAX) NULL,
people_fully_vaccinated VARCHAR(MAX) NULL,
total_boosters VARCHAR(MAX) NULL,
new_vaccinations VARCHAR(MAX) NULL,
new_vaccinations_smoothed VARCHAR(MAX) NULL,
total_vaccinations_per_hundred VARCHAR(MAX) NULL,
people_vaccinated_per_hundred VARCHAR(MAX) NULL,
people_fully_vaccinated_per_hundred VARCHAR(MAX) NULL,
total_boosters_per_hundred VARCHAR(MAX) NULL,
new_vaccinations_smoothed_per_million VARCHAR(MAX) NULL,
new_people_vaccinated_smoothed VARCHAR(MAX) NULL,
new_people_vaccinated_smoothed_per_hundred VARCHAR(MAX) NULL,
stringency_index VARCHAR(MAX) NULL,
population_density VARCHAR(MAX) NULL,
median_age VARCHAR(MAX) NULL,
aged_65_older VARCHAR(MAX) NULL,
aged_70_older VARCHAR(MAX) NULL,
gdp_per_capita VARCHAR(MAX) NULL,
extreme_poverty VARCHAR(MAX) NULL,
cardiovasc_death_rate VARCHAR(MAX) NULL,
diabetes_prevalence VARCHAR(MAX) NULL,
female_smokers VARCHAR(MAX) NULL,
male_smokers VARCHAR(MAX) NULL,
handwashing_facilities VARCHAR(MAX) NULL,
hospital_beds_per_thousand VARCHAR(MAX) NULL,
life_expectancy VARCHAR(MAX) NULL,
human_development_index VARCHAR(MAX) NULL,
excess_mortality_cumulative_absolute VARCHAR(MAX) NULL,
excess_mortality_cumulative VARCHAR(MAX) NULL,
excess_mortality VARCHAR(MAX) NULL,
excess_mortality_cumulative_per_million VARCHAR(MAX) NULL
);
*/

/* Insert Values dbo.covid_deaths */
/*
BULK INSERT [dbo].[covid_deaths]
FROM '/Users/goncalosilva/Desktop/covid_deaths.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO
*/
/* Insert Values dbo.covid_vaccination */
/*
BULK INSERT [dbo].[covid_deaths]
FROM '/Users/goncalosilva/Desktop/covid_vaccination.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO
*/

-- TEST IF EVERYTHING IS OK WITH COVID_DEATHS DATA
SELECT * 
FROM [COVID_Portfolio].[dbo].[covid_deaths]
ORDER BY 3,4

-- TEST IF EVERYTHING IS OK WITH COVID_VACCINATION DATA 
SELECT * 
FROM [COVID_Portfolio].[dbo].[covid_vaccination]
ORDER BY 3,4

-- SELECT DATA THAT WE ARE GOING TO BE USING 
SELECT [location], [date], total_cases, new_cases, total_deaths, population
FROM [COVID_Portfolio].[dbo].[covid_deaths]
ORDER BY 1,3  /* order by total_cases */

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- SHOWS THE LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY
SELECT [location], [date], total_cases, total_deaths, ((total_deaths/total_cases)*100) AS death_percentage
FROM [COVID_Portfolio].[dbo].[covid_deaths]
WHERE [location] LIKE '%states'
ORDER BY 1,3

-- LOOKING AT TOTAL CASES VS POPULATION
-- SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID
SELECT [location], [date], population, total_cases, ((total_cases/population)*100) AS percent_population_infected
FROM [COVID_Portfolio].[dbo].[covid_deaths]
WHERE [location] LIKE '%stats'
ORDER BY 1,3

-- LOOKING AT COUNTRIES WITH HIGHEST INFEVTION RATE COMPARE TO POPULATION
SELECT [location], population, MAX(total_cases) as highest_infection_count, (MAX(total_cases/population)*100) AS percent_population_infected
FROM [COVID_Portfolio].[dbo].[covid_deaths]
GROUP BY population, [location]
ORDER BY percent_population_infected DESC

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT [location], MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM [COVID_Portfolio].[dbo].[covid_deaths]
WHERE continent IS NULL
GROUP BY [location]
ORDER BY total_deaths_count DESC

/* THERE IS SOME DIFFERENCE BETWEEN TOTCONTINENTS FROM PREVIOUS AND AFTER QUERY */

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT [continent], MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM [COVID_Portfolio].[dbo].[covid_deaths]
WHERE continent IS NOT NULL
GROUP BY [continent]
ORDER BY total_deaths_count DESC

-- GLOBAL NUMBERS
SELECT [date], SUM(new_cases) AS total_new_cases, SUM(new_deaths) AS total_new_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM [COVID_Portfolio].[dbo].[covid_deaths]
WHERE [continent] is not null
GROUP BY [date]
ORDER BY 1,2
 
-- GLOBAL NUMBERS - AVG. DEATH PERCENTAGE OVER THE WORLD
SELECT SUM(new_cases) AS total_new_cases, SUM(new_deaths) AS total_new_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM [COVID_Portfolio].[dbo].[covid_deaths]
WHERE [continent] is not null
ORDER BY 1,2

-- JOIN COVID DEATHS AND VACCINATION
SELECT *
FROM [COVID_Portfolio].[dbo].[covid_deaths] AS dea 
JOIN [COVID_Portfolio].[dbo].[covid_vaccination] AS vac
    ON dea.location = vac.location
    AND dea.date = vac.date

-- LOOKING AT TOTAL POPULATION VS VACCINATION
SELECT [dea].[continent], [dea].[location], [dea].[date], 
[dea].[population], [vac].[new_vaccinations]
FROM [COVID_Portfolio].[dbo].[covid_deaths] AS [dea] 
JOIN [COVID_Portfolio].[dbo].[covid_vaccination] AS [vac]
    ON [dea].[location] = [vac].[location]
    AND [dea].[date] = [vac].[date]
WHERE [dea].[continent] IS NOT NULL
ORDER BY 2,3

-- ROLLING PEOPLE VACCINATED
SELECT [dea].[continent], [dea].[location], [dea].[date], 
[dea].[population], [vac].[new_vaccinations], 
SUM([vac].[new_vaccinations]) OVER (PARTITION BY [dea].[location] ORDER BY [dea].[location], [dea].[date]) AS rolling_people_vaccinated
FROM [COVID_Portfolio].[dbo].[covid_deaths] AS [dea] 
JOIN [COVID_Portfolio].[dbo].[covid_vaccination] AS [vac]
    ON [dea].[location] = [vac].[location]
    AND [dea].[date] = [vac].[date]
WHERE [dea].[continent] IS NOT NULL
ORDER BY 2,3

-- USE CTE
WITH population_vs_vaccination (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) -- SAME NUMBERS OF COLUMNS
AS 
(
SELECT [dea].[continent], [dea].[location], [dea].[date], 
[dea].[population], [vac].[new_vaccinations], 
SUM([vac].[new_vaccinations]) OVER (PARTITION BY [dea].[location] ORDER BY [dea].[location], [dea].[date]) AS rolling_people_vaccinated
FROM [COVID_Portfolio].[dbo].[covid_deaths] AS [dea] 
JOIN [COVID_Portfolio].[dbo].[covid_vaccination] AS [vac]
    ON [dea].[location] = [vac].[location]
    AND [dea].[date] = [vac].[date]
WHERE [dea].[continent] IS NOT NULL
)
SELECT * , (rolling_people_vaccinated/population)*100 AS percentage_vaccinated
FROM population_vs_vaccination

-- USE TEMPORARY TABLE
DROP TABLE IF EXISTS percent_population_vaccinated
CREATE TABLE percent_population_vaccinated
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rolling_people_vaccinated NUMERIC
)
INSERT INTO percent_population_vaccinated
SELECT [dea].[continent], [dea].[location], [dea].[date], 
[dea].[population], [vac].[new_vaccinations], 
SUM([vac].[new_vaccinations]) OVER (PARTITION BY [dea].[location] ORDER BY [dea].[location], [dea].[date]) AS rolling_people_vaccinated
FROM [COVID_Portfolio].[dbo].[covid_deaths] AS [dea] 
JOIN [COVID_Portfolio].[dbo].[covid_vaccination] AS [vac]
    ON [dea].[location] = [vac].[location]
    AND [dea].[date] = [vac].[date]
WHERE [dea].[continent] IS NOT NULL

SELECT * , (rolling_people_vaccinated/population)*100 AS rpvacc
FROM percent_population_vaccinated

-- CREATING VIEW TO STORE DATA FOR LATER (VISUALIZATIONS)
CREATE VIEW percentage_population_vacc AS 
SELECT [dea].[continent], [dea].[location], [dea].[date], 
[dea].[population], [vac].[new_vaccinations], 
SUM([vac].[new_vaccinations]) OVER (PARTITION BY [dea].[location] ORDER BY [dea].[location], [dea].[date]) AS rolling_people_vaccinated
FROM [COVID_Portfolio].[dbo].[covid_deaths] AS [dea] 
JOIN [COVID_Portfolio].[dbo].[covid_vaccination] AS [vac]
    ON [dea].[location] = [vac].[location]
    AND [dea].[date] = [vac].[date]
WHERE [dea].[continent] IS NOT NULL

SELECT *
FROM percentage_population_vacc