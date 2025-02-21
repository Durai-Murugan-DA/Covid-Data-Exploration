Select *
From PortfolioProjects..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From PortfolioProjects..CovidVaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProjects..CovidDeaths
order by 1,2


--Looking at Total cases vs Total Deaths


SELECT location, 
       date, 
       total_cases, 
       total_deaths, 
       (CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0)) * 100 AS DeathPercentage
FROM PortfolioProjects..CovidDeaths
Where location like '%states%'
ORDER BY 1,2


--Looking at Total cases vs population


SELECT location, 
       date, 
	   population,
       total_cases,  
       (CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100 AS Percentpopulationinfected
FROM PortfolioProjects..CovidDeaths
--Where location like '%states%'
ORDER BY 1,2
 

 --Looking at countries with highest infection rate compared to population
 

 SELECT location, 
       population,
       MAX(total_cases) AS HighestInfectionCount,
       MAX(CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProjects..CovidDeaths
where continent is not null
--WHERE location LIKE '%states%' 
GROUP BY location, population
ORDER BY PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population


SELECT location, 
       MAX(Cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProjects..CovidDeaths
--WHERE location LIKE '%states%'
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

--Showing Continents with the highest death count per population


SELECT continent , 
       MAX(Cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProjects..CovidDeaths
--WHERE location LIKE '%states%'
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


--Global Numbers


SELECT 
    SUM(CAST(new_cases AS INT)) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    (SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(CAST(new_cases AS INT)), 0)) AS DeathPercentage
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2;


--looking at total population vs vacccinations


select dea.continent,dea.location,dea.date,dea. population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as Rollingpeoplevaccicinated
--,(Rollingpeoplevaccicinated/population)*100
From PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2,3


  --USE CTE


  WITH PopvsVac AS (
    SELECT 
        dea.continent,
        dea.location,
        dea.date,
        NULLIF(CAST(dea.population AS BIGINT), 0) AS Population, -- Ensure BIGINT
        CAST(vac.new_vaccinations AS BIGINT) AS New_vaccinations, -- Force BIGINT conversion
        SUM(CAST(vac.new_vaccinations AS BIGINT)) 
            OVER (PARTITION BY dea.location ORDER BY dea.date) 
            AS Rollingpeoplevaccicinated
    FROM PortfolioProjects..CovidDeaths dea
    JOIN PortfolioProjects..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, 
       (CAST(Rollingpeoplevaccicinated AS FLOAT) / CAST(Population AS FLOAT)) * 100 
       AS VaccinationPercentage
FROM PopvsVac;


--Temp Table


Drop table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    Date DATETIME,
    Population BIGINT,
    New_vaccinations BIGINT,
    Rollingpeoplevaccicinated BIGINT
);

INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent,
    dea.location,
    TRY_CAST(dea.date AS DATETIME) AS Date,  -- Convert safely
    NULLIF(CAST(dea.population AS BIGINT), 0) AS Population,
    CAST(vac.new_vaccinations AS BIGINT) AS New_vaccinations,
    SUM(CAST(vac.new_vaccinations AS BIGINT)) 
        OVER (PARTITION BY dea.location ORDER BY TRY_CAST(dea.date AS DATETIME)) 
        AS Rollingpeoplevaccicinated
FROM PortfolioProjects..CovidDeaths dea
JOIN PortfolioProjects..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND TRY_CAST(dea.date AS DATETIME) IS NOT NULL;  -- Ensure only valid dates

SELECT *, 
       (CAST(Rollingpeoplevaccicinated AS FLOAT) / CAST(Population AS FLOAT)) * 100 
       AS VaccinationPercentage
FROM #PercentPopulationVaccinated;


--creating View to store data for later visualizations


Drop view if exists PercentPopulationVaccinated
create view PercentPopulationVaccinated as 
select 
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        sum(convert(INT, vac.new_vaccinations)) 
            over (partition by dea.location order by dea.location, dea.date) 
            as Rollingpeoplevaccicinated
    from PortfolioProjects..CovidDeaths dea
    join PortfolioProjects..CovidVaccinations vac
        on dea.location = vac.location
        and dea.date = vac.date
    where dea.continent is not null

	select *
	From PercentPopulationVaccinated












