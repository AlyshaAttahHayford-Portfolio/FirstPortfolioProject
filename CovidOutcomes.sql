

--Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying in each coutry after contracting Covid-19
/**Select location,date,total_cases,total_deaths, (CAST(total_deaths as numeric))/(Cast(total_cases as numeric))*100 as Death_Percentage
From CovidProject..['CovidDeaths']
Order by 1,2**/

--Looking at the Total Cases vs Percentage
--Shows what percentage of the total population caught Covid-19
/**Select location,date,population,total_cases, (CAST(total_cases as numeric))/(Cast(population as numeric))*100 as CasesbyPopulation_Percentage
From CovidProject..['CovidDeaths']
where location like '%kingdom%'
Order by 1,2**/

--Looking at Countries with the Highest Infection rate compared to Population Size
/**Select location,population,MAX(cast(total_cases as int)) as HighestInfectionCount, MAX((CAST(total_cases as numeric))/(Cast(population as numeric)))*100 as Percent_Population_Infected
From CovidProject..['CovidDeaths']
Group by location,population
Order by Percent_Population_Infected desc**/


--Showing Countries with the Highest Death Count Per Population
/**Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..['CovidDeaths']
Where continent is not null
Group by location
Order by TotalDeathCount desc**/

--Showing all 7 Continents with their Total Population Death Count in descending order
/**Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..['CovidDeaths']
Where continent is null
Group by location
Order by TotalDeathCount desc**/

--Calculating Global Numbers according to the date.
/**Select date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(NULLIF(new_deaths,0))/SUM(NULLIF(new_cases,0))*100 as DeathPercentage 
From CovidProject..['CovidDeaths']
Where continent is not null
Group By date
Order by 1 desc**/

--Calculating the Overall Global Numbers of Cases, Deaths and Proportion of Cases to Deaths in %.
/**Select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(NULLIF(new_deaths,0))/SUM(NULLIF(new_cases,0))*100 as DeathPercentage 
From CovidProject..['CovidDeaths']
Where continent is not null
Order by 1,2**/

--Looking at the latest Total Population vs Vaccinations
--Using a CTE
/**With PopulationnVaccinations(Continent,Location, Date, Population, New_Vaccinations, VaccinatedPopulation)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(bigint,vac.new_vaccinations)) Over (partition by dea.location order by dea.location,dea.date) as VaccinatedPopulation
From CovidProject..['CovidDeaths'] dea
join CovidProject..['CovidVaccincations'] vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
)
Select*,(VaccinatedPopulation/Population)*100 as VacPercent
From PopulationnVaccinations
Order by date desc**/

--Looking at the latest Total Population vs Vaccinations
--TEMP TABLE
/**Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
VaccinatedPopulation numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(bigint,vac.new_vaccinations)) Over (partition by dea.location order by dea.location,dea.date) as VaccinatedPopulation
From CovidProject..['CovidDeaths'] dea
join CovidProject..['CovidVaccincations'] vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null

Select*,(VaccinatedPopulation/Population)*100 as VacPercent
From #PercentPopulationVaccinated
Order by date desc**/

--Creating a View to Use for Later Visualisations
USE CovidProject
GO
Create View PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(bigint,vac.new_vaccinations)) Over (partition by dea.location order by dea.location,dea.date) as VaccinatedPopulation
From CovidProject..['CovidDeaths'] dea
join CovidProject..['CovidVaccincations'] vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null








