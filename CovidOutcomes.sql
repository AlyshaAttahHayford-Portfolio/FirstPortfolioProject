

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
Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..['CovidDeaths']
Where continent is null
Group by location
Order by TotalDeathCount desc



