-- Select Data that we are going to be starting with

Select * from dbo.covid_deaths$
Select * from dbo.covid_vaccinations$


Select Location, date, total_cases, new_cases, total_deaths, population
From dbo.covid_deaths$
Where continent is not null 
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.covid_deaths$
Where location like '%states%'
and continent is not null 
order by 1,2


select Location,Population,max(total_cases) as highest_cases,max(total_cases/population)*100 as percent_no
from dbo.covid_deaths$
group by location,population



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.covid_deaths$
where continent is not null 
order by 1,2



-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.covid_deaths$ dea
Join dbo.covid_vaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With cte (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
From dbo.covid_deaths$ dea
Join dbo.covid_vaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

)
Select *
From cte

