SELECT *
FROM CovidDeath

SELECT *
FROM CovidVaccination

SELECT *
FROM CovidDeath
ORDER BY 3,4

SELECT *
FROM CovidVaccination
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeath
ORDER BY 1,2

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM CovidDeath
ORDER BY 1,2

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM CovidDeath
WHERE location = 'india'
ORDER BY 1,2


SELECT location, date, population, total_cases, new_cases,  (total_cases/population)*100 as case_vs_population
FROM CovidDeath
WHERE location = 'india'
ORDER BY 1,2


SELECT location,  population, MAX(total_cases) AS highest_case_count,   max((total_cases/population)*100) AS total_case_vs_population
FROM CovidDeath
GROUP BY location, population
ORDER BY 1,2


SELECT location,  population, MAX(total_cases) AS highest_case_count,   max((total_cases/population)*100) AS total_case_vs_population
FROM CovidDeath
GROUP BY location, population
ORDER BY 4 DESC


SELECT continent, location,  population, MAX(cast(total_deaths as int)) AS highest_death_count
FROM CovidDeath
WHERE continent IS NOT NULL
GROUP BY  continent, location, population

SELECT continent, location,  population, MAX(cast(total_deaths as int)) AS highest_death_count
FROM CovidDeath
WHERE continent IS NOT NULL
GROUP BY  continent, location, population



SELECT  location,  population, MAX(cast(total_deaths as int)) AS highest_death_count
FROM CovidDeath
WHERE continent IS NULL
GROUP BY location, population
ORDER BY 3 DESC


SELECT date, SUM(new_cases) as total_cases,  SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
FROM CovidDeath
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as total_cases,  SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
FROM CovidDeath
WHERE continent is NOT NULL
ORDER BY 1,2



SELECT *
FROM CovidDeath

SELECT *
FROM CovidVaccination

SELECT *
FROM CovidDeath dea
JOIN CovidVaccination vac
ON dea.location = vac.location
AND dea.date = vac.date

SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date )
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY  2, 3

SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) AS rolling_people_vaccinated
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL  --and dea.location = 'india'
ORDER BY  2, 3


SELECT vac.new_vaccinations 
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL  and  ISNUMERIC (Cast(vac.new_vaccinations as int)) <> 0

Update CovidVaccination
set new_vaccinations=cast(replace(new_vaccinations,'Alpha #','') as int)
where new_vaccinations like 'Alpha #%'
And new_vaccinations is Null


SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) 
AS rolling_people_vaccinated
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY  2, 3


WITH pop_vs_vac (continent, location ,date , population , new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) 
AS rolling_people_vaccinated
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY  2, 3
)
--SELECT * , (rolling_people_vaccinated/population)*100
--FROM pop_vs_vac

SELECT location , Max((rolling_people_vaccinated/population)*100) AS percentage_of_people_vaccinated
FROM pop_vs_vac
WHERE continent = 'ASIA'
GROUP BY location
ORDER BY percentage_of_people_vaccinated desc



TEMP TABLE

CREATE TABLE #PercentagePopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric)

INSERT INTO #PercentagePopulationVaccinated

SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) 
AS rolling_people_vaccinated
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL


SELECT * , (rolling_people_vaccinated/population)*100
FROM #PercentagePopulationVaccinated


DROP TABLE IF EXISTS #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric)

INSERT INTO #PercentagePopulationVaccinated

SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) 
AS rolling_people_vaccinated
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is NOT NULL


SELECT * , (rolling_people_vaccinated/population)*100
FROM #PercentagePopulationVaccinated


DROP TABLE IF EXISTS #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric)

INSERT INTO #PercentagePopulationVaccinated

SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) 
AS rolling_people_vaccinated
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL


SELECT * , (rolling_people_vaccinated/population)*100
FROM #PercentagePopulationVaccinated


 CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION

CREATE VIEW PercentagePopulationVaccinated AS
SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) 
AS rolling_people_vaccinated
FROM CovidDeath dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL

SELECT *
FROM PercentagePopulationVaccinated
