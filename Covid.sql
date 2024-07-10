--Datas which are majorly required

select location, date, total_cases,new_cases, total_deaths, population from [covid-death]
order by 1,2

--Total death vs total cases
select location, date, total_cases,total_deaths,(total_deaths*1.0/total_cases)*100 as Death_percentage from [covid-death]
order by 1,2

--Total cases vs population
select location, date,population, total_cases,(total_cases*1.0/population)*100 as infectionRate from [covid-death]
order by 1,2

--Highest infection rate per country
select location,population, max(total_cases) as Highest_infectionCount,((max(total_cases*1.0))/population)*100 as infectionRate from [covid-death]
group by population, location
order by infectionRate desc

--Countries with highest death count per population
select location,population, max(total_deaths) as highest_DeathCount,((max(total_deaths*1.0))/population)*100 as DeathRate from [covid-death]
group by population, location
order by DeathRate desc

--Total deaths per continent
select continent, SUM(max_total_deaths) as totalDeaths
from (select continent, location, MAX(total_deaths) AS max_total_deaths
     from [covid-death] group by continent, location) 
AS subquery
group by continent
order by totalDeaths DESC;

--Death percentage
select sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,(sum((new_deaths)*1.0)/sum(new_cases))*100 as Death_percentage from [covid-death]

--Total vaccination percentage (method 1)
select death.location, death.population, death.date, new_vaccinations,
    sum(new_vaccinations) over (PARTITION BY death.location order by death.date) AS peopleVaccinated,
    (sum(new_vaccinations) over (PARTITION BY death.location order by death.date) * 1.0 / death.population) * 100 as vaccinationPercent
from [covid-death] as death INNER JOIN [covid-vaccine] as vac on
    death.location = vac.location AND death.date = vac.date order by 1, 2, 3;

