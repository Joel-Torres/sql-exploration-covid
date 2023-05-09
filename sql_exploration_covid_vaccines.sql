SELECT iso_code, continent, location
FROM `covid-19-pandemic-385422.covid_vaccines.covid_vaccines` 
WHERE location = "United States"
LIMIT 1000

SELECT *
FROM `covid-19-pandemic-385422.covid_vaccines.covid_vaccines` 
LIMIT 1000

-- Joined tables covid_death and covid_vaccine
SELECT *
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` AS dea
JOIN `covid-19-pandemic-385422.covid_vaccines.covid_vaccines` AS vac
 ON dea.location = vac.location
 AND dea.date = vac.date

--  Looking at Total Population vs  new Vaccinations on a daily basis.
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` AS dea
JOIN `covid-19-pandemic-385422.covid_vaccines.covid_vaccines` AS vac
ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

--  Looking at Total Population vs  new Vaccinations on a daily basis and running total
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS runningct_ppl_vac
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` AS dea
JOIN `covid-19-pandemic-385422.covid_vaccines.covid_vaccines` AS vac
ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

--  Looking at Total Population vs  new Vaccinations on a daily basis and running total 
-- Using CTE but not able to run alias

WITH dea as  (SELECT continent, location, date, population FROM `covid-19-pandemic-385422.covid_deaths.covid_death` ),
vac as (SELECT new_vaccinations, location, date FROM `covid-19-pandemic-385422.covid_vaccines.covid_vaccines`)

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS runningct_ppl_vac 
-- , (runningct_ppl_vac/population)*100 AS percent_vaccinated
FROM dea
JOIN vac
ON (dea.location = vac.location
 AND dea.date = vac.date)
WHERE dea.continent IS NOT NULL
-- ORDER BY 2, 3


-- Looking at Total Population vs  new Vaccinations on a daily basis and running total and percentage of vaccinated on each day
-- Using Common Table Expression (CTE) This allows the use of alias in SELECT clause because of use of WITH 
WITH popvsvac as ( 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS runningct_ppl_vac
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` AS dea
JOIN `covid-19-pandemic-385422.covid_vaccines.covid_vaccines` AS vac
ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2, 3
)

SELECT *, (runningct_ppl_vac/population)*100 AS percent_vaccinated
FROM popvsvac

-- TEMP TABLE

DROP TABLE IF exists `covid-19-pandemic-385422.covid_deaths.percent_pop_vac`;
CREATE TABLE `covid-19-pandemic-385422.covid_deaths.percent_pop_vaccinated` (
  continent string,
  location string,
  date date,
  population integer,
  new_vaccinations integer,
  runningct_ppl_vac numeric
);

INSERT INTO `covid-19-pandemic-385422.covid_deaths.percent_pop_vaccinated`
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS runningct_ppl_vac
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` AS dea
JOIN `covid-19-pandemic-385422.covid_vaccines.covid_vaccines` AS vac
ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2, 3
);
SELECT *, (runningct_ppl_vac/population)*100 AS percent_pop_vac
FROM `covid-19-pandemic-385422.covid_deaths.percent_pop_vaccinated`

-- Creating View to store data for later visualizations and I should create Views based on all the different sql functions written here.

CREATE VIEW `covid-19-pandemic-385422.covid_deaths.percent_population_vaccinated` AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS runningct_ppl_vac
FROM `covid-19-pandemic-385422.covid_deaths.covid_death` AS dea
JOIN `covid-19-pandemic-385422.covid_vaccines.covid_vaccines` AS vac
ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2, 3

SELECT *
FROM `covid-19-pandemic-385422.covid_deaths.percent_population_vaccinated`
