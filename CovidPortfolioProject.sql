Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total cases vs total deaths 
-- shows the likelihood of dying 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'death percentage'
From PortfolioProject..CovidDeaths
Where location = 'Canada'
order by 1,2

-- Looking at the total cases vs the population 

Select Location, date, population, total_cases, (total_cases/population)*100 as 'cases percentage'
From PortfolioProject..CovidDeaths
Where location = 'Canada'
order by 1,2

-- Countries with highest infection rate compared to population

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as 'Cases Percent'
From PortfolioProject..CovidDeaths
--Where location = 'Canada'
Group by location, population
order by 4 desc

--Showing country with the highest death rate

Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc

--by continent 
--Showing contintents with the highest death count
Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
Group by location
order by TotalDeathCount desc

--Global numbers 
Select date, Sum(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

-- Looking at total population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(decimal,vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location, dea.date) as RollingNewVac
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Use CTE
With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingNewVac)
as(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(decimal,vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location, dea.date) as RollingNewVac
	From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
)
Select *, (RollingNewVac/Population)*100 as VacVsPop
From PopvsVac


--Temp Table 
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_Vaccinations numeric,
	RollingNewVac numeric
)

Insert into #PercentPopulationVaccinated
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(decimal,vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location, dea.date) as RollingNewVac
	From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null

Select *, (RollingNewVac/Population)*100 as VacVsPop
From #PercentPopulationVaccinated

--Creating View to store data for viz later

Create View PercentPopulationVaccinated as 
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(decimal,vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location, dea.date) as RollingNewVac
	From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
