
SELECT * 
from [Portfolio Project] ..CovidDeaths$
where Continent is not null
order by 3,4


SELECT * 
from [Portfolio Project] ..CovidVaccinations$
order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project] ..CovidDeaths$
where Continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from [Portfolio Project] ..CovidDeaths$
where location like '%india%' 
and Continent is not null
order by 1,2

--Looking at Total Cases vs Population 

SELECT location, date, population, total_cases, (total_cases/population)*100 as Percent_Population_Infected
from [Portfolio Project] ..CovidDeaths$
--where location like '%india%' 
order by 1,2 

--Countries with Highest Infection Rate compared to population 

SELECT location, Population, Max(total_cases) as Highest_Infection_Count, Max((total_cases/Population))*100 as Percent_Population_Infected
from [Portfolio Project] ..CovidDeaths$
--where location like '%india%' 
where Continent is not null
Group by Location, Population
order by Percent_Population_Infected desc

--Countries with Highest Death Count per Population

SELECT location, Max(cast(Total_deaths as int)) as Total_Death_count 
from [Portfolio Project] .. CovidDeaths$
--where location like '%india%' 
where Continent is not null
Group by Location
order by Total_Death_count desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathcount
From [Portfolio Project].. CovidDeaths$
--Where location like '%india%’
Where continent is not null
Group by continent 
order by TotalDeathCount desc

--Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
From [Portfolio Project].. CovidDeaths$
--Where location like '%india%’
where continent is not null
--Group By date
order by 1,2

--Lokking at Total Population vs Vaccinations 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
-- (RollingPeoplevaccinated/population)*100
from [Portfolio Project].. CovidDeaths$ dea
join [Portfolio Project].. CovidVaccinations$ vac 
On dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
--order by 2,3  
) 
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac

--Use CTE 

With Popvsvac (Continent, Location, Date, Population, New_Vaccinations, RollingPeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (Convert (int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea. location,
dea.Date) as RollingPeoplevaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject. .CovidDeaths$ dea
join PortfolioProject. .CovidVaccinations$ vac
On dea.location = vac. location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
) 
select *, (RollingPeoplevaccinated/Population)*100
From PopvsVac 

-- TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (Convert (int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea. location,
dea.Date) as RollingPeoplevaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject. .CovidDeaths$ dea
join PortfolioProject. .CovidVaccinations$ vac
On dea.location = vac. location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualisations 

Create View PercentPopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea. location,
dea.Date) as RollingPeopleVvaccinated
--, (RollingPeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
On dea.location = vac. location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3 

Select * 
From PercentPopulationVaccinated

    

 

 

 





















