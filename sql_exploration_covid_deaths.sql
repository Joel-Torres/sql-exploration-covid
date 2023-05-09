SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` 
ORDER BY location, date

-- Looking at Total Cases vs Total Deaths
-- Percent chance of death from covid in the United States
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercent
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` 
WHERE LOWER(location) LIKE '%states%'
ORDER BY location, date

--Total Cases vs Population provides data on percent of pop who contact covid
SELECT location, date, total_cases,population, (total_cases/population)*100 AS PercentPos
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` 
WHERE LOWER(location) LIKE '%states%'
ORDER BY location, date

--Each countries infection rate
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPos
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` 
GROUP BY location, population
ORDER BY PercentPos DESC

--Countries with their Highest Death Count
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` 
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Continents with their Highest Death Count
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` 
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

--We can also look at Continents this way
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` 
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS BY CONTINENT
SELECT date, continent, location, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SAFE_DIVIDE(SUM(cast(new_deaths as numeric)), SUM(cast(new_cases as numeric)))*100 AS DeathPercentage
FROM `covid-19-pandemic-385422.covid_deaths.covid_death`
WHERE continent is null
GROUP BY date, continent, location
ORDER BY 1, 2

-- GLOBAL NUMBERS ACROSS THE WORLD (here I'm adding up total new cases, total_deaths for the day across all countries because of WHERE clause)
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SAFE_DIVIDE(SUM(cast(new_deaths as numeric)), SUM(cast(new_cases as numeric)))*100 AS DeathPercentage
FROM `covid-19-pandemic-385422.covid_deaths.covid_death`
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2

-- GLOBAL NUMBERS ACROSS THE WORLD (here I'm adding up total new cases, total_deaths for the day across all continents because of WHERE clause)
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SAFE_DIVIDE(SUM(cast(new_deaths as numeric)), SUM(cast(new_cases as numeric)))*100 AS DeathPercentage
FROM `covid-19-pandemic-385422.covid_deaths.covid_death`
WHERE continent is null
GROUP BY date
ORDER BY 1, 2

-- GLOBAL NUMBERS ACROSS THE WORLD (all dates and locations summed)
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SAFE_DIVIDE(SUM(cast(new_deaths as numeric)), SUM(cast(new_cases as numeric)))*100 AS DeathPercentage
FROM `covid-19-pandemic-385422.covid_deaths.covid_death`
WHERE continent is not null
ORDER BY 1, 2